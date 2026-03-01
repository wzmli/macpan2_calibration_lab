library(macpan2)
library(tidyverse);theme_set(theme_bw())
library(shellpipes)

spec <- rdsRead("model")

simdat <- rdsRead("sims")

time_steps <- 200

print(spec)
print(simdat)

## modifying the determinstic simulation as data
obsdat <- (simdat
	|> mutate(value = round(value))
)

basis_cols = 5
basis_rows = time_steps
X = splines::ns(1:basis_rows
	, basis_cols
	, intercept = TRUE
	, Boundary.knots = c(1, basis_rows)
	)

timevar_spec = mp_tmb_insert_glm_timevar(spec
	, parameter_name = "beta"
	, design_matrix = X
	, timevar_coef = rep(0,
	basis_cols)
	, link_function = mp_log
)

spline_cal <- (mp_tmb_calibrator(spec = timevar_spec |> mp_rk4()
	, data = obsdat
	, time = mp_sim_bounds(1, time_steps)
	, traj = "incidence"
	, par = list(time_var_beta = mp_normal(0,log(1)))
	, outputs = c("beta_thing","incidence")
	)
)


spline_opt = mp_optimize(spline_cal)

## Check optimized fit

print(spline_opt)

## Plots

fitted_data = mp_trajectory_sd(spline_cal, conf.int = TRUE)

gg <- (ggplot(data = (fitted_data |> filter(matrix == "incidence")))
  + geom_line(aes(time, value))
  + geom_ribbon(aes(time, ymin = conf.low, ymax = conf.high)
    , alpha = 0.2
    , colour = "red"
  )
  + geom_point(data=obsdat,aes(time, value))
)

print(gg)

betaplot <- (ggplot(data = (fitted_data |> filter(matrix == "beta_thing")))
	+ geom_line(aes(time, value))
	+ geom_ribbon(aes(time, ymin=conf.low, ymax=conf.high)
		, alpha = 0.2
		, color = "red"
	)
)

print(betaplot)
