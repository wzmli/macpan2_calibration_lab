library(macpan2)
library(ggplot2);theme_set(theme_bw())
library(shellpipes)

spec <- rdsRead()

# set number of time steps in simulation
time_steps = 200L

# simulator object
sir_simulator = mp_simulator(  
    model = spec
  , time_steps = time_steps
  , outputs = "incidence"
)

# simulate trajectory

## Deterministic simulation

det_sim <- (mp_trajectory(sir_simulator))

print(det_sim)

gg <- (ggplot(det_sim,aes(x=time,y=value))
	+ geom_point()
)

print(gg)

## Stochastic simulation
### Note, for stochastic simulation, we need a calibrated object because it needs to know what parameters are non-deterministic

rdsSave(det_sim)

