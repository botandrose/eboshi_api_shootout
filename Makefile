impls := rack sinatra
.PHONY: $(impls)

define makerule =
$1: 
	@cd $1 && bin/setup; cd ..
	@bin/bats test/test.bats
	@cd $1 && bin/teardown; cd ..
endef

$(foreach _,${impls},$(eval $(call makerule,$_)))
