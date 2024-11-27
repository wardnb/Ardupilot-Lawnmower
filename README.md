# Ardupilot-Lawnmower
A project to convert my Ego Lawnmower into a robot


# Robotic Lawnmower Control

This repository contains resources and code for building a robotic lawnmower using:
- A **Matek F405-HDTE flight controller** running ArduPilot.
- A hoverboard motor controller with custom firmware ([hoverboard-firmware-hack-FOC](https://github.com/EFeru/hoverboard-firmware-hack-FOC)).
- Integration via UART communication.

## Overview

The robotic lawnmower uses ArduPilot to provide navigation and control, sending motor commands to the hoverboard motor controller via UART. The hoverboard controller drives two hub motors in a differential steering configuration.

### Key Features:
- **Custom Lua script** for ArduPilot to send motor commands via UART.
- Direct integration with hoverboard motor controller firmware.
- Supports telemetry and navigation via ArduPilot.

---

## Hardware Setup

### Components
1. **Flight Controller**: Matek F405-HDTE
2. **Hoverboard Motor Controller**: Running the [hoverboard-firmware-hack-FOC](https://github.com/EFeru/hoverboard-firmware-hack-FOC).
3. **Motors**: Hoverboard hub motors (x2).
4. **Receiver**: ELRS receiver connected to the Matek F405-HDTE.
5. **Power Supply**: 36V battery for the motor controller, stepped down for the flight controller if needed.

### Wiring
1. **UART Connections**:
   - Matek F405-HDTE UART TX → Motor controller RX
   - Matek F405-HDTE UART RX → Motor controller TX
   - GND → GND
2. **Voltage Levels**:
   - Ensure UART signals are compatible (e.g., 3.3V or 5V). Use a level shifter if required.

---

## Software Configuration

### 1. Hoverboard Firmware
- Flash the hoverboard controller with [hoverboard-firmware-hack-FOC](https://github.com/EFeru/hoverboard-firmware-hack-FOC).
- Set the `USART` variant in the firmware for UART communication.
- Configure the baud rate to `115200`.

### 2. ArduPilot Configuration
1. Enable scripting: