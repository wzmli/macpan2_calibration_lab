library(macpan2)
library(tidyverse);theme_set(theme_bw())
library(shellpipes)
rpcall("timevar_calibrate.Rout timevar_calibrate.R timevar_sims.rds timevar_model.rds")

spec <- rdsRead("model")

simdat <- rdsRead("sims")


print(spec)
print(simdat)

## modifying the determinstic simulation as data
obsdat <- (simdat
	|> mutate(value = round(value))
)

sir_cal = mp_tmb_calibrator(
    spec = spec
  , data = obsdat
  
  ## name the trajectory variable, with a name that
  ## is the same in both the spec and the data
  , traj = "incidence"  
  
  ## fit the following parameters
#  , par = c("beta", "gamma")
  , par = c("beta_values")
)

sir_opt = mp_optimize(sir_cal)

## Check optimized fit

print(sir_opt)

rdsSave(sir_opt)


## Plots

fitted_data = mp_trajectory_sd(sir_cal, conf.int = TRUE)

gg <- (ggplot(obsdat)
  + geom_point(aes(time, value))
  + geom_line(data = fitted_data, aes(time, value))
  + geom_ribbon(aes(time, ymin = conf.low, ymax = conf.high)
    , data = fitted_data
    , alpha = 0.2
    , colour = "red"
  )
)

print(gg)

