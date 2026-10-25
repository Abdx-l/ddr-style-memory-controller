# DDR-Style Memory Controller

Parameterized multi-bank educational controller with open-row tracking, ACT/READ/WRITE/PRECHARGE/REFRESH scheduling, configurable timing, a command-checking behavioral memory, and a self-checking testbench. The interface permits one outstanding request; this models command scheduling rather than a DDR PHY or a JEDEC-compliant device.

## Run

Requires Icarus Verilog 11+ and make. Run `make test`. All timing values are clock cycles. A request is accepted on valid && ready; rvalid completes reads and writes.

## Development

Source, examples, and checks are included in this repository. External services and optional tools are identified in the run instructions.
