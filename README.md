# Gaussian-Blur-Project
The contents of this repositorium form a part of a Bachelor Studies Thesis project. It was done in a team of three people.

The project as a whole implements a hardware-software system for counting free parking spaces in a bird's-eye photograph of a parking lot. The system uses different image-processing techniques. One of these techniques - the Gaussian Blur, is accelerated by being implemented in hardware on an FPGA board. The RTL design of a Gaussian Blur IP represents the second part of this project and is showcased in this repository. It is also the part in which I specialized in.

The full project consists of four parts:
1. System level design - The initial software algorithm is analyzed and divided into software and hardware components of the future finished system.
2. RTL design - The hardware part of the system is designed using a Hardware Description Language, optimizations are made and the system is tested on a bare-metal app.
3. Functional verification - The functionality of the designed IP module is verified using UVM methodology.
4. Driver and application development - The software and hardware parts of the system are integrated and made suitable for use.
