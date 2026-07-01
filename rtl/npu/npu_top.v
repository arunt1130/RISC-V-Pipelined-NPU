// ══════════════════════════════════════════════════════════════
// NPU Top Module — Memory-Mapped Systolic Array Accelerator
//
// Contains:
//   1. Register Bank — stores matrices A, B and exposes results C
//   2. Controller FSM — manages computation lifecycle
//   3. Systolic Array instance — the ARRAY_SIZE x ARRAY_SIZE MAC grid
//
// Memory Map (offsets from NPU base, i.e. address[7:0]).
// MAT = ARRAY_SIZE*ARRAY_SIZE. For the default ARRAY_SIZE=4:
//   [0,     MAT)   Matrix A elements          (  0–15)
//   [MAT,  2*MAT)  Matrix B elements          ( 16–31)
//   [2*MAT,3*MAT)  Matrix C results, READ-ONLY( 32–47)
//   3*MAT          Control register (write 1 to start)   (48)
//   3*MAT+1        Status register  (read: bit 0 = done) (49)
//
// The 8-bit offset space limits ARRAY_SIZE to 9 (3*81+1 = 244).
// Practical power-of-two sizes: 2, 4, 8.
//
// CPU usage:
//   1. Write A and B elements via sw instructions
//   2. Write 1 to the control register to start
//   3. Poll the status register until done=1
//   4. Read results from the Matrix C region
// ══════════════════════════════════════════════════════════════
module NPU_Top #(
    parameter ARRAY_SIZE = 4,
    parameter DATA_WIDTH = 8,
    parameter ACC_WIDTH  = 32
)(
    input         clk, reset,
    // CPU memory-mapped interface (active in MEM stage)
    input         mem_write,
    input         mem_read,
    input  [7:0]  address,       // offset within NPU space
    input  [31:0] write_data,
    output reg [31:0] read_data
);

// ── Derived memory map ──
localparam MAT = ARRAY_SIZE * ARRAY_SIZE;
localparam [7:0] B_BASE      = MAT;
localparam [7:0] C_BASE      = 2 * MAT;
localparam [7:0] CTRL_ADDR   = 3 * MAT;
localparam [7:0] STATUS_ADDR = 3 * MAT + 1;

// A full multiply takes 3*ARRAY_SIZE - 2 feed cycles (0-indexed:
// the last feed cycle is 3*ARRAY_SIZE - 3).
localparam [7:0] LAST_CYCLE = 3 * ARRAY_SIZE - 3;

// ╔══════════════════════════════════════════════════╗
// ║              REGISTER BANK                        ║
// ╚══════════════════════════════════════════════════╝

// Matrix A and B storage — DATA_WIDTH-bit elements, MAT each
reg [DATA_WIDTH-1:0] A_reg [0:MAT-1];  // A[i*ARRAY_SIZE+j] = A[i][j]
reg [DATA_WIDTH-1:0] B_reg [0:MAT-1];  // B[i*ARRAY_SIZE+j] = B[i][j]
integer k;

// ╔══════════════════════════════════════════════════╗
// ║           CONTROLLER FSM                          ║
// ╚══════════════════════════════════════════════════╝

// States
localparam IDLE    = 2'b00;  // waiting for start
localparam CLEAR   = 2'b01;  // zeroing accumulators
localparam COMPUTE = 2'b10;  // feeding skewed data
localparam DONE    = 2'b11;  // results ready

reg [1:0] state;
reg [7:0] cycle_count;  // 0 .. LAST_CYCLE during COMPUTE

// Start pulse — fires the cycle the CPU writes 1 to the control register
wire start_pulse = mem_write && (address == CTRL_ADDR) && write_data[0];

// Control outputs to the systolic array
wire sa_enable = (state == COMPUTE);
wire sa_clear  = (state == CLEAR);
wire done      = (state == DONE);

// FSM state transitions
always @(posedge clk or posedge reset) begin
    if (reset) begin
        state       <= IDLE;
        cycle_count <= 8'b0;
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
                cycle_count <= 8'b0;
            end
            COMPUTE: begin
                if (cycle_count == LAST_CYCLE) begin
                    // All feed cycles complete
                    state <= DONE;
                end
                else begin
                    cycle_count <= cycle_count + 8'd1;
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
//   Row i feeds A[i][cycle_count - i] while
//   i <= cycle_count <= i + ARRAY_SIZE - 1, else 0.
//
// Top inputs (columns of B, skewed by column index):
//   Col j feeds B[cycle_count - j][j] over the same window.
//
// Row skew and column skew have identical structure, so one
// loop drives both lane buses.

reg [ARRAY_SIZE*DATA_WIDTH-1:0] left_in_bus;  // lane i = row i of A
reg [ARRAY_SIZE*DATA_WIDTH-1:0] top_in_bus;   // lane j = col j of B

integer lane;
integer feed_idx;
integer cc;  // cycle_count widened for index arithmetic
always @(*) begin
    left_in_bus = {ARRAY_SIZE*DATA_WIDTH{1'b0}};
    top_in_bus  = {ARRAY_SIZE*DATA_WIDTH{1'b0}};
    feed_idx    = 0;
    cc          = {24'b0, cycle_count};
    if (state == COMPUTE) begin
        for (lane = 0; lane < ARRAY_SIZE; lane = lane + 1) begin
            if (cc >= lane && cc <= lane + ARRAY_SIZE - 1) begin
                feed_idx = cc - lane;  // element index within the lane
                left_in_bus[lane*DATA_WIDTH +: DATA_WIDTH] =
                    A_reg[lane*ARRAY_SIZE + feed_idx];       // A[lane][feed_idx]
                top_in_bus[lane*DATA_WIDTH +: DATA_WIDTH]  =
                    B_reg[feed_idx*ARRAY_SIZE + lane];       // B[feed_idx][lane]
            end
        end
    end
end


// ╔══════════════════════════════════════════════════╗
// ║           SYSTOLIC ARRAY INSTANCE                 ║
// ╚══════════════════════════════════════════════════╝

// Register-bank index widths — the address decode guarantees the
// offsets are in range, so the extra address bits can be dropped.
localparam IDX_W = (MAT > 1) ? $clog2(MAT) : 1;
wire [7:0]       b_offset = address - B_BASE;
wire [IDX_W-1:0] a_index  = address[IDX_W-1:0];
wire [IDX_W-1:0] b_index  = b_offset[IDX_W-1:0];

// Result read: when the CPU reads the Matrix C region, select
// the right PE accumulator.
wire [7:0] result_sel = address - C_BASE;
wire [ACC_WIDTH-1:0] array_result;

Systolic_Array #(
    .ARRAY_SIZE(ARRAY_SIZE),
    .DATA_WIDTH(DATA_WIDTH),
    .ACC_WIDTH(ACC_WIDTH)
) sa (
    .clk(clk), .reset(reset),
    .enable(sa_enable), .clear(sa_clear),
    .left_in(left_in_bus),
    .top_in(top_in_bus),
    .result_sel(result_sel),
    .result_out(array_result)
);


// ╔══════════════════════════════════════════════════╗
// ║           CPU WRITE LOGIC                         ║
// ╚══════════════════════════════════════════════════╝

always @(posedge clk or posedge reset) begin
    if (reset) begin
        for (k = 0; k < MAT; k = k + 1) begin
            A_reg[k] <= {DATA_WIDTH{1'b0}};
            B_reg[k] <= {DATA_WIDTH{1'b0}};
        end
    end
    else if (mem_write) begin
        if (address < B_BASE)
            A_reg[a_index] <= write_data[DATA_WIDTH-1:0];
        else if (address < C_BASE)
            B_reg[b_index] <= write_data[DATA_WIDTH-1:0];
        // Control register is handled by the start_pulse wire
    end
end


// ╔══════════════════════════════════════════════════╗
// ║           CPU READ LOGIC                          ║
// ╚══════════════════════════════════════════════════╝

always @(*) begin
    if (mem_read) begin
        if (address < B_BASE)
            // Read back Matrix A (sign-extended — elements are signed int8)
            read_data = {{(32-DATA_WIDTH){A_reg[a_index][DATA_WIDTH-1]}},
                         A_reg[a_index]};
        else if (address < C_BASE)
            // Read back Matrix B (sign-extended)
            read_data = {{(32-DATA_WIDTH){B_reg[b_index][DATA_WIDTH-1]}},
                         B_reg[b_index]};
        else if (address < CTRL_ADDR)
            // Read Matrix C result from the systolic array
            read_data = array_result;
        else if (address == STATUS_ADDR)
            // Status register: bit 0 = done
            read_data = {31'b0, done};
        else
            read_data = 32'b0;
    end
    else
        read_data = 32'b0;
end

endmodule
