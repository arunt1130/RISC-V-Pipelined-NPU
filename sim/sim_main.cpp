#include <iostream>
#include <verilated.h>
#include "Vtop.h"

int main(int argc, char** argv) {
    // Initialize Verilator arguments (passes +firmware=... to Verilog)
    Verilated::commandArgs(argc, argv);
    
    // Instantiate the top module
    Vtop* top = new Vtop;
    
    // Initial Reset
    top->clk = 0;
    top->reset = 1;
    top->host_rx_data = 0;
    
    // Tick a few times to propagate reset
    for (int i = 0; i < 10; i++) {
        top->clk = !top->clk;
        top->eval();
    }
    
    // Release reset (This triggers negedge reset in Verilog, loading the firmware)
    top->reset = 0;
    top->clk = !top->clk;
    top->eval();
    
    std::cout << "[Host] Reset released, SoC running." << std::endl;
    
    // Simulation state
    uint64_t main_time = 0;
    bool command_sent = false;
    bool response_received = false;
    
    while (!Verilated::gotFinish() && main_time < 500) {
        // Toggle Clock
        top->clk = !top->clk;
        top->eval();
        
        // Evaluate on rising edge
        if (top->clk) {
            // After 20 cycles, inject a command
            if (main_time == 20 && !command_sent) {
                top->host_rx_data = 10; // Let's pass 10 as the multiplier
                std::cout << "[Host] Cycle " << main_time << ": Injected Command = 10" << std::endl;
                command_sent = true;
            }
            
            // Check for CPU response via MMIO (host_tx_valid)
            if (top->host_tx_valid) {
                std::cout << "[Host] Cycle " << main_time << ": Received Response from SoC = " 
                          << top->host_tx_data << std::endl;
                          
                // The expected math: C[0][0] = (2*3) + (4*10) = 6 + 40 = 46.
                if (top->host_tx_data == 46) {
                    std::cout << "[Host] Math verified correctly! 2*3 + 4*10 = 46" << std::endl;
                    response_received = true;
                } else {
                    std::cout << "[Host] ERROR: Expected 46, got " << top->host_tx_data << std::endl;
                }
                
                // Clear the command to acknowledge
                top->host_rx_data = 0;
                
                // End simulation shortly after
                break;
            }
            
            main_time++;
        }
    }
    
    if (!response_received) {
        std::cout << "[Host] ERROR: Timeout waiting for SoC response." << std::endl;
        return 1;
    } else {
        std::cout << "[Host] Simulation completed successfully." << std::endl;
    }
    
    top->final();
    delete top;
    return 0;
}
