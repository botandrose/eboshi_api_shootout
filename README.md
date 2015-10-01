EBOSHI API SHOOTOUT
===================

[![Build Status](https://travis-ci.org/botandrose/eboshi_api_shootout.svg?branch=master)](http://travis-ci.org/botandrose/eboshi_api_shootout)

This repo contains multiple implementations of the same API: An API for the Eboshi time tracking and invoicing system.

Each implementation shares the MySQL database, and a language-agnostic test suite.

* To run the tests for all implementations, run `make`.
* To run the tests for one implementation, run `make <implementation>`, e.g. `make elixir_phoenix`.

Implementation requirements
---------------------------

Each implementation lives in its own subdirectory, and has the following requirements:

* Must provide a `bin/setup` executable. This runs the server on port 6969 after installing any needed dependencies, etc (assume that the language itself is installed).
* The API response must conform to the [jsonapi.org](http://jsonapi.org) standard.
* Timestamps must be in UTC and formatted in ISO 8601.
* Must implement the following [JSON endpoints](https://github.com/botandrose/eboshi_api_shootout/blob/master/test/test.rb).

Configuration
-------------

Some environment variables if you want to customize the access configuration:

* `EBOSHI_API_SHOOTOUT_MYSQL_USERNAME` _default: 'root'_
* `EBOSHI_API_SHOOTOUT_MYSQL_PASSWORD` _default: none_
* `EBOSHI_API_SHOOTOUT_MYSQL_DATABASE` _default: eboshi_test_
