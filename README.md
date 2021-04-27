# ZonotopeContainmentProblem

This repository contains algorithms to solve the general zonotope containment problem, as well as some test cases to test them.

By using the launcher.m file, you can recreate the different plots used for the paper "On the co-NP-Completeness of the Zonotope Containment Problem". Do take into account, that the .mat files are already given, in order to speed up the process. If you wish to recreate these files all by yourself, be warned: This could take several days, and the results for the runtime may depend on your architecture. In our study, we used an Intel Core i7-8650U CPU @ 1.9GHz with 24GB memory for the runtime measurements.

The optimisation is currently implemented using the surrogateopt function from MATLAB. Previously, this was done with fmincon instead. For the sake of reproducibility, we kept the old results and placed them in the fmincon_legacy folder. This folder is self-contained, i.e., no other files from the main folder are required.