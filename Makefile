# otherwise make sees e.g. the directory named 'test' and thinks its done.
.PHONY: test rack
test:
	@bin/bats test/test.bats


# RACK
rack: rack_setup test rack_teardown

rack_setup:
	@cd rack && bin/setup

rack_teardown:
	@cd rack && bin/teardown
