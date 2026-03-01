# macpan2_calibration_lab

Please use [macpan2 workshop](https://canmod.github.io/macpan-workshop/) as the starter guide.

The goal is to be able to fit time-varying parameters by (1) piece-wise or (2) spline-based. 

Please install the r package "shellpipes". To install "shellpipes", please run "devtools:::install_github("dushoff/shellpipes")"

Please run the following Rscripts in order. 

model.R : Create an macpan SIR model spec

simulate.R : Deterministic and stochastic simulation of the SIR model spec

calibrate.R : Fitting the model to the deterministic simulation 

timevar_model.R : Create a time varying SIR model with piecewise beta values

timevar_sims.R : Deterministic simulation of the piece-wise timevarying beta SIR

timevar_calibrate.R : Fitting the piece-wise timevarying SIR to the deterministic simulation

timevar_calibrate2.R : Starting with the original SIR model spec (model.R), fit a spline-based time varying beta SIR to the piece-wise determinsitic simulation



