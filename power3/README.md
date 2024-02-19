THe aim of this project is to create a simple custom instruction slave and
interface it to a NiosII soft-core processor.

## RTL

Out of convenience, a simple slave that calculates the cube of an input was
created. The module `power3.sv` can be found in the rtl sub-repository. It
takes an input `i_x` and calculates its cube in 3 clock cycles. Its schematic is
shown below:

![power3](images/power3.png)

## TB

A simple C++ Tb was created. The Tb drives the input and after 3 clock cycles
verifies that the output is what it expects.

To create the Tb, run a simulation and generate waveforms displaying the
signals: `cd tb && make all`.

