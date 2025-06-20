# 🌀 CORDIC Algorithm (Verilog)

This project implements a **CORDIC (COordinate Rotation DIgital Computer)** algorithm in Verilog to compute sine and cosine values efficiently using only shift and add operations — ideal for FPGA or low-resource hardware.

---

## Contents

- `cordic.v` - Core CORDIC module
- `cordic_tb.v` - Testbench for sweeping through an angle range
- `cordic_plot.py` - Python script for plotting and validating output

---

## Parameters You Can Control

| Parameter | File         | Line | Description                                |
|-----------|--------------|------|--------------------------------------------|
| `N`       | `cordic_tb.v`| 23   | Number of CORDIC iterations (accuracy)     |
| `A1`      | `cordic_tb.v`| 24   | Lower angle in degrees                     |
| `A2`      | `cordic_tb.v`| 25   | Upper angle in degrees                     |

---

## How to Run

### Simulate

1. Open `cordic_tb.v` in your simulator (Vivado, etc.).
2. Click **"Run All"** — the simulation must run completely (initial runtime is too short).
3. The output is saved to `cordic_output.csv`.

> ℹ️ Want real-time console output?  
> Uncomment the `$display` lines in `cordic_tb.v`.

---

### Plot the Results

Make sure Python (and `matplotlib`, `pandas`) is installed.

```bash
python cordic_plot.py

