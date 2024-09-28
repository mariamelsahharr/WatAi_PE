<!---

This file is used to generate your project datasheet. Please fill in the information below and delete any unused
sections.

You can also include images in this folder and reference them in the markdown. Each image must be less than
512 kb in size, and the combined size of all images must be less than 1 MB.
-->

## How it works

This is a PE that will have 
1) ability to do MAC operations
2) mixed precision support
3) connect to MxN array
4) Add register files for each processing elements
5) control signals that enable a weight stationary dataflow
    5a) In the processing element, you’d need control signals like WRITE, READ, and ADDR to write data to the regfile, read data from the regfile, and specify the regfile address for the read/write.
    5b) In the array as a whole, it’d be too complicated to model the data distribution scheme. So instead, just add control signals to determine when a PE is accumulating a temporal partial sum and needs to be sent inputs vs. when a PE is done and needs to have its output transferred to a global buffer.
6) Adding a run length encoding encoder and decoder module to the PE array control signals to optimise for sparsity.

## How to test

Nothing yet so far

## External hardware

Nothing so far