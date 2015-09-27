This repo contains multiple implementations of the same API. An API for the Eboshi time tracking and invoicing system.

Each implementation shares the MySQL database schema, and a language-agnostic test suite written in shell.

To run the tests for one implementation, run e.g. `make rack`.

Each implementation lives in its own subdirectory, and must implement `bin/setup` and `bin/teardown`.

* `bin/setup`: Gets the server running on port 6969. This also includes installing any dependencies, etc. We can assume that the language itself is installed.
* `bin/teardown`: Shuts down the server, and cleans up any test artifacts.
