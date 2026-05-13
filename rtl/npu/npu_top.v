// ══════════════════════════════════════════════════════════════
// NPU Top Module — Memory-Mapped Systolic Array Accelerator
//
// Contains:
//   1. Register Bank — stores matrices A, B and exposes results C
//   2. Controller FSM — manages computation lifecycle
//   3. Systolic Array instance — the 4×4 MAC grid
//
// Memory Map (offsets from NPU base, i.e. address[7:0]):
//   0–15:  Matrix A (16 × 8-bit elements, written as 32-bit words)
//   16–31: Matrix B (16 × 8-bit elements, written as 32-bit words)
//   32–47: Matrix C (16 × 32-bit results, READ-ONLY)
//   48:    Control register (write 1 to start computation)
//   49:    Status register  (read: bit 0 = done)
//
// CPU usage:
//   1. Write A and B elements via sw instructions
//   2. Write 1 to control register (offset 48) to start
//   3. Poll status register (offset 49) until done=1
//   4. Read results from offsets 32–47
// ══════════════════════════════════════════════════════════════
module NPU_Top(
    input         clk, reset,
    // CPU memory-mapped interface (active in MEM stage)
    input         mem_write,
    input         mem_read,
    input  [7:0]  address,       // offset within NPU space
    input  [31:0] write_data,
    output reg [31:0] read_data
);

// ╔══════════════════════════════════════════════════╗
// ║              REGISTER BANK                        ║
// ╚══════════════════════════════════════════════════╝

// Matrix A and B storage — 8-bit elements, 16 each
reg [7:0] A_reg [0:15];  // A[i*4+j] = A[i][j]
reg [7:0] B_reg [0:15];  // B[i*4+j] = B[i][j]
integer k;

// ╔══════════════════════════════════════════════════╗
// ║           CONTROLLER FSM                          ║
// ╚══════════════════════════════════════════════════╝

// States
localparam IDLE    = 2'b00;  // waiting for start
localparam CLEAR   = 2'b01;  // zeroing accumulators
localparam COMPUTE = 2'b10;  // feeding skewed data (7 cycles)
localparam DONE    = 2'b11;  // results ready

reg [1:0] state;
reg [2:0] cycle_count;  // 0–6 for 7 compute cycles

// Start pulse — fires the cycle the CPU writes 1 to the control register
wire start_pulse = mem_write && (address == 8'd48) && write_data[0];

// Control outputs to the systolic array
wire sa_enable = (state == COMPUTE);
wire sa_clear  = (state == CLEAR);
wire done      = (state == DONE);

// FSM state transitions
always @(posedge clk or posedge reset) begin
    if (reset) begin
        state       <= IDLE;
        cycle_count <= 3'b0;
    end
    else begin
        case (state)
            IDLE: begin
                if (start_pulse)
                    state <= CLEAR;
            end
            CLEAR: begin
                // One cycle to zero all accumulators
                state       <= COMPUTE;
                cycle_count <= 3'b0;
            end
            COMPUTE: begin
                if (cycle_count == 3'd6) begin
                    // All 7 cycles complete (0–6)
                    state <= DONE;
                end
                else begin
                    cycle_count <= cycle_count + 1;
                end
            end
            DONE: begin
                // Stay in DONE until a new start
                if (start_pulse)
                    state <= CLEAR;
            end
        endcase
    end
end

// ╔══════════════════════════════════════════════════╗
// ║         SKEWED DATA FEEDING LOGIC                 ║
// ╚══════════════════════════════════════════════════╝
//
// For matrix multiply C = A × B, data must be skewed so that
// A[i][k] and B[k][j] arrive at PE(i,j) at the same time.
//
// Left inputs (rows of A, skewed by row index):
//   Row i feeds A[i][cycle_count - i] when (cycle_count >= i)
//   and (cycle_count - i <= 3), else feeds 0.
//
// Top inputs (columns of B, skewed by column index):
//   Col j feeds B[cycle_count - j][j] when (cycle_count >= j)
//   and (cycle_count - j <= 3), else feeds 0.

reg [7:0] left_in_0, left_in_1, left_in_2, left_in_3;
reg [7:0] top_in_0,  top_in_1,  top_in_2,  top_in_3;

always @(*) begin
    // ── Row 0: skew = 0, feeds at cycles 0–3 ──
    if (state == COMPUTE && cycle_count <= 3)
        left_in_0 = A_reg[cycle_count];             // A[0][cycle_count]
    else
        left_in_0 = 8'b0;

    // ── Row 1: skew = 1, feeds at cycles 1–4 ──
    if (state == COMPUTE && cycle_count >= 1 && cycle_count <= 4)
        left_in_1 = A_reg[4 + (cycle_count - 1)];   // A[1][cycle_count-1]
    else
        left_in_1 = 8'b0;

    // ── Row 2: skew = 2, feeds at cycles 2–5 ──
    if (state == COMPUTE && cycle_count >= 2 && cycle_count <= 5)
        left_in_2 = A_reg[8 + (cycle_count - 2)];   // A[2][cycle_count-2]
    else
        left_in_2 = 8'b0;

    // ── Row 3: skew = 3, feeds at cycles 3–6 ──
    if (state == COMPUTE && cycle_count >= 3 && cycle_count <= 6)
        left_in_3 = A_reg[12 + (cycle_count - 3)];  // A[3][cycle_count-3]
    else
        left_in_3 = 8'b0;

    // ── Col 0: skew = 0, feeds at cycles 0–3 ──
    if (state == COMPUTE && cycle_count <= 3)
        top_in_0 = B_reg[cycle_count * 4];           // B[cycle_count][0]
    else
        top_in_0 = 8'b0;

    // ── Col 1: skew = 1, feeds at cycles 1–4 ──
    if (state == COMPUTE && cycle_count >= 1 && cycle_count <= 4)
        top_in_1 = B_reg[(cycle_count - 1) * 4 + 1]; // B[cycle_count-1][1]
    else
        top_in_1 = 8'b0;

    // ── Col 2: skew = 2, feeds at cycles 2–5 ──
    if (state == COMPUTE && cycle_count >= 2 && cycle_count <= 5)
        top_in_2 = B_reg[(cycle_count - 2) * 4 + 2]; // B[cycle_count-2][2]
    else
        top_in_2 = 8'b0;

    // ── Col 3: skew = 3, feeds at cycles 3–6 ──
    if (state == COMPUTE && cycle_count >= 3 && cycle_count <= 6)
        top_in_3 = B_reg[(cycle_count - 3) * 4 + 3]; // B[cycle_count-3][3]
    else
        top_in_3 = 8'b0;
end


// ╔══════════════════════════════════════════════════╗
// ║           SYSTOLIC ARRAY INSTANCE                 ║
// ╚══════════════════════════════════════════════════╝

// Result read: when CPU reads offset 32–47, select the right PE
wire [3:0] result_sel = address - 8'd32;
wire [31:0] array_result;

Systolic_Array_4x4 sa(
    .clk(clk), .reset(reset),
    .enable(sa_enable), .clear(sa_clear),
    .left_in_0(left_in_0), .left_in_1(left_in_1),
    .left_in_2(left_in_2), .left_in_3(left_in_3),
    .top_in_0(top_in_0),   .top_in_1(top_in_1),
    .top_in_2(top_in_2),   .top_in_3(top_in_3),
    .result_sel(result_sel),
    .result_out(array_result)
);


// ╔══════════════════════════════════════════════════╗
// ║           CPU WRITE LOGIC                         ║
// ╚══════════════════════════════════════════════════╝

always @(posedge clk or posedge reset) begin
    if (reset) begin
        for (k = 0; k < 16; k = k + 1) begin
            A_reg[k] <= 8'b0;
            B_reg[k] <= 8'b0;
        end
    end
    else if (mem_write) begin
        // Matrix A: offsets 0–15
        if (address <= 8'd15)
            A_reg[address] <= write_data[7:0];
        // Matrix B: offsets 16–31
        else if (address >= 8'd16 && address <= 8'd31)
            B_reg[address - 8'd16] <= write_data[7:0];
        // Control register (offset 48) is handled by start_pulse wire
    end
end


// ╔══════════════════════════════════════════════════╗
// ║           CPU READ LOGIC                          ║
// ╚══════════════════════════════════════════════════╝

always @(*) begin
    if (mem_read) begin
        if (address <= 8'd15)
            // Read back Matrix A (zero-extended to 32 bits)
            read_data = {24'b0, A_reg[address]};
        else if (address >= 8'd16 && address <= 8'd31)
            // Read back Matrix B
            read_data = {24'b0, B_reg[address - 8'd16]};
        else if (address >= 8'd32 && address <= 8'd47)
            // Read Matrix C result from systolic array
            read_data = array_result;
        else if (address == 8'd49)
            // Status register: bit 0 = done
            read_data = {31'b0, done};
        else
            read_data = 32'b0;
    end
    else
        read_data = 32'b0;
end

endmodule
