## This is macpan2 calibration lab

current: target
-include target.mk
Ignore = target.mk

vim_session:
	bash -cl "vmt"

######################################################################

### Makestuff

Sources += Makefile

Ignore += makestuff
msrepo = https://github.com/dushoff

## ln -s ../makestuff . ## Do this first if you want a linked makestuff
Makefile: makestuff/00.stamp
makestuff/%.stamp: | makestuff
	- $(RM) makestuff/*.stamp
	cd makestuff && $(MAKE) pull
	touch $@
makestuff:
	git clone --depth 1 $(msrepo)/makestuff

Sources += README.md
Sources += $(wildcard *.R)

model.Rout: model.R
	$(pipeRcall)

simulate.Rout: simulate.R model.rds
	$(pipeRcall)

calibrate.Rout: calibrate.R model.rds simulate.rds
	$(pipeRcall)

timevar_model.Rout: timevar_model.R model.rds
	$(pipeRcall)

# timevar_sims.Rout: timevar_model.R
timevar_sims.Rout: timevar_sims.R timevar_model.rds
	$(pipeRcall)

timevar_calibrate.Rout: timevar_calibrate.R timevar_sims.rds timevar_model.rds
	$(pipeRcall)

timevar_calibrate2.Rout: timevar_calibrate2.R timevar_sims.rds model.rds
	$(pipeRcall)

-include makestuff/os.mk

-include makestuff/pipeR.mk

-include makestuff/git.mk
-include makestuff/visual.mk
