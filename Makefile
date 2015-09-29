impls := $(shell find . -maxdepth 1 -mindepth 1 ! -name 'bin' ! -name 'test' ! -name '.git' ! -name '.idea' -type d)
.PHONY: $(impls)

all: $(impls)

define makerule
$1:
	@echo $1:
	@cd test && npm install; cd ..
	@cd $1 && bin/setup; cd ..
	@bin/mocha
	@cd $1 && bin/teardown; cd ..
	@echo ""
endef

$(foreach _,${impls},$(eval $(call makerule,$_)))
