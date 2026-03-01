library(macpan2)
library(tidyverse);theme_set(theme_bw())
library(shellpipes)
rpcall("timevar_sims.Rout timevar_sims.R timevar_model.rds")

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

rdsSave(det_sim)

gg <- (ggplot(det_sim,aes(x=time,y=value))
	+ geom_line()
)

print(gg)

