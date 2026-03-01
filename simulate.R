library(macpan2)
library(tidyverse);theme_set(theme_bw())
library(shellpipes)
rpcall("simulate.Rout simulate.R model.rds")

spec <- rdsRead()

# setting simulation parameters
time_steps <- 200L
outputs <- c("incidence")
nsims <- 10

# model parameter
beta <- 0.2

# simulator object
sir_simulator = mp_simulator(  
    model = spec
  , time_steps = time_steps
  , outputs = outputs
)

# simulate trajectory

## Deterministic simulation

det_sim <- (mp_trajectory(sir_simulator))


## Stochastic simulation

parameterized_sim <- (mp_tmb_calibrator(mp_euler_multinomial(spec)
	, par = "beta"
	, time = mp_sim_bounds(1,time_steps)
	, outputs = outputs
	)
)

beta_sample <- rnorm(n=nsims,mean=beta,sd=0.001)

sim_fn <- function(x){
	stochsim <- mp_trajectory_par(parameterized_sim, list(beta=x))
}

stoch_sim <- (lapply(beta_sample,sim_fn)
	|> bind_rows(.id="iter")
)

## Plotting simulations

gg <- (ggplot(det_sim,aes(x=time,y=value))
	+ geom_line()
	+ geom_line(data=stoch_sim,aes(x=time,y=value,group=iter),alpha=0.1)
)

print(gg)

simdf <- (det_sim
	|> mutate(iter = "0")
	|> bind_rows(stoch_sim)
)

rdsSave(simdf)
