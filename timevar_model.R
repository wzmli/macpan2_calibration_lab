library(macpan2)
library(shellpipes)

spec <- rdsRead()

beta_changepoints <- c(1, 40, 80)
beta_values <- c(0.4,0.1,0.2)

expr <- list(beta ~ time_var(beta_values, beta_changepoints)

timevar_spec <- (spec
	|> mp_tmb_insert(phase = "during"
		, at = 1
		, expressions = expr
		)

