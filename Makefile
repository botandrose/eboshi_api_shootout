# otherwise make sees e.g. the directory named 'test' and thinks its done.
.PHONY: test rack
test:
	bin/bats test/test.bats

rack: setup test teardown

setup:
	cd rack && bin/setup

teardown:
	cd rack && bin/teardown
