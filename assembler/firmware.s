# Firmware Runtime Loop (Host MMIO & NPU)
#
# This program runs continuously, polling the Host Interface at address 512.
# When the Host sends a command (a non-zero value), the CPU feeds that value
# into the Systolic Array NPU as a matrix element, triggers the NPU, 
# and returns the matrix multiplication result back to the Host.

init:
    # Set up static NPU matrix elements
    addi x1, x0, 2
    sw   x1, 256(x0)     # A[0][0] = 2
    addi x2, x0, 3
    sw   x2, 272(x0)     # B[0][0] = 3
    addi x4, x0, 4
    sw   x4, 257(x0)     # A[0][1] = 4

poll_host:
    lw   x3, 512(x0)     # Read from Host (address 512)
    beq  x3, x0, poll_host # If 0, keep polling

    # Command received! x3 contains the host payload.
    # Feed the payload into NPU Matrix B
    sw   x3, 276(x0)     # B[1][0] = Host Payload

    # Trigger NPU Start
    addi x5, x0, 1
    sw   x5, 304(x0)     # Start Reg = 1

poll_npu:
    lw   x6, 305(x0)     # Read NPU Status Reg
    beq  x6, x0, poll_npu

    # Read Result Matrix C
    lw   x7, 288(x0)     # Read C[0][0]
                         # C = A[0][0]*B[0][0] + A[0][1]*B[1][0]
                         # C = (2 * 3) + (4 * Host Payload)

    # Send Result back to Host
    sw   x7, 512(x0)     # Write result to Host TX (address 512)

wait_clear:
    lw   x3, 512(x0)     # Read from Host again
    beq  x3, x0, poll_host # If host reset the payload to 0, go back to polling
    beq  x0, x0, wait_clear # Otherwise wait until host clears it
