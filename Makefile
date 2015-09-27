.PHONY: test # otherwise make sees the directory named 'test' and thinks its done.
test:
	bin/bats test/test.bats
