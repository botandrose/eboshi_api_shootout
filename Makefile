impls := $(shell find . -maxdepth 1 -mindepth 1 ! -name 'bin' ! -name 'test' ! -name '.git' -type d)
.PHONY: $(impls)

all: $(impls)

define makerule
$1: 
	@echo $1:
	@cd $1 && bin/setup; cd ..
	@bin/bats test/test.bats
	@cd $1 && bin/teardown; cd ..
	@echo ""
endef

$(foreach _,${impls},$(eval $(call makerule,$_)))
