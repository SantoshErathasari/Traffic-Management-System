# Traffic Management System

This repository provides the implementation of a traffic light controller system, complete with various submodules such as a state machine, push-button filters, a synchronizer module, and a top-level file. Each module is implemented in VHDL and designed for FPGA-based projects or digital design purposes.

## Table of Contents
- [Overview](#overview)
- [Modules](#modules)
  - [Top File](#top-file)
  - [State Machine](#state-machine)
  - [PB_Filters](#pb_filters)
  - [Synchronizer](#synchronizer)
  - 

## Overview
The traffic light controller system consists of various modules working together to manage traffic signals effectively. The primary modules include:
- **Top File**: Integrates all modules to create the complete traffic light controller system.
- **State Machine**: Controls the flow of traffic signals based on input conditions.
- **Push-Button Filters (PB_Filters)**: Debounces and filters noisy push-button inputs.
- **Synchronizer**: Synchronizes asynchronous inputs to the system clock.
- **Push-Button Inverters** (PB_inverters)**: Inverts polarity of buttons.

Each module has been written in VHDL, allowing easy simulation and synthesis for hardware design using Intel Quartus Prime

## Modules

### Top File
The top file acts as the main integration point for the entire traffic light controller system. It combines the state machine, push-button filters, and synchronizer to manage the traffic light sequence efficiently. 

#### Features
- Interfaces with hardware inputs (e.g., push-buttons) and outputs (e.g., traffic lights).
- Handles the clock and reset signals to synchronize the system.
- Ensures seamless communication between submodules.

### State Machine
The state machine controls the traffic light sequence and transitions between states based on the input conditions (e.g., North-South and East-West button presses). It ensures proper timing and synchronization of the lights. The traffic system cycles through states 0-->15 if no buttons are pressed. If push buttons are activated, the system reacts in an appropriate way to accomodate pedestrains by changing which side goes green and red. 

#### Features
- Implements 16 distinct states to manage light transitions.
- Processes input signals to determine state transitions.
- Outputs control signals to manage the traffic lights (e.g., red, amber, green).

### PB_Filters
The PB_Filters module debounces and filters noisy push-button signals. This ensures that only clean, stable signals are passed to the state machine.

### PB_inverters
The PB_inverters module inverts the push buttons from active low polarity to active high polarity with the usage of not gates. 

### Synchronizer
The Synchronizer module ensures that asynchronous inputs are synchronized with the system clock to prevent metastability issues.

#### Features
- Works on all 4 sides of a busy intersection accomodating pedestrains in an effecient manner.
