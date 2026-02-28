library(macpan2)
library(shellpipes)

spec <- rdsRead()

# set number of time steps in simulation
time_steps = 100L

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


## Stochastic simulation
### Note, for stochastic simulation, we need a calibrated object because it needs to know what parameters are non-deterministic



