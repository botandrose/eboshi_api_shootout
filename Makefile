impls := $(shell bin/impls)
.PHONY: $(impls)

all: $(impls)

define makerule
$1:
	@bin/test $1
endef

$(foreach _,${impls},$(eval $(call makerule,$_)))
