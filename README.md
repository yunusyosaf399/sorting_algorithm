# Sorting Algorithm Implementation in Verilog

This project implements a hardware-based **sorting algorithm** using Verilog, featuring a **controller, datapath, RAM module, and testbench**. The design ensures correct operation with **proper signal synchronization** and **state transitions**.

## 📌 Features
- **Fully synchronous design** with clock and reset.
- **RAM-based data storage** for sorting elements.
- **Finite State Machine (FSM) Controller** to handle sorting logic.
- **Comparator-based swap logic** for sorting elements in ascending order.
- **Testbench with predefined data** for verification.

## 📁 Project Architecture


# Datapath and Controller Interface
![Datapath](images/datapath.jpeg)

# Block Diagram of Execution Unit
![Block Diagram](images/block.jpeg)

# FSM Controller
![FSM Controller](images/FSM_Controller.jpeg)

# Datapath
![Data Path](images/datapath.jpeg)

## 🚀 How It Works

1. **Initialization**:  
   - The RAM is loaded with predefined values.
   - Sorting starts when the `start` signal is asserted.

2. **Sorting Process**:  
   - Uses a **finite state machine (FSM)** to control the sorting logic.
   - Implements a **swap-based algorithm** where elements are compared and swapped if needed.
   - Iterates through the elements until sorting is complete.

3. **Completion**:  
   - The `done` signal is asserted when sorting is finished.
   - RAM contents can be read to verify the sorted order.

## 🛠️ Simulation & Testing

### **1️⃣ Running the Simulation**
Use a Verilog simulator such as **ModelSim, VCS, or Icarus Verilog** to simulate the design.

#### **Using Icarus Verilog (`iverilog`):**
```sh
iverilog -o sorting_test sorting_top_tb.v sorting_top.v controller.v datapath.v RAM.v
vvp sorting_test
