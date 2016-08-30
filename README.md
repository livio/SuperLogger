# SuperLogger
A logging framework for iOS that provides multiple, modular, logging components.

Despite being the very first pre-release version, this build has most of the core features:

* Modular loggers - Only pull what you want from Cocoapods by specifying subspecs, or don't to get everything available. Log to the Console, ASL, a file, or a web server
* Modular logs - When setting up, place files into modules to specify log levels for a wide swath of your project and to see at a glance where a log is coming from. Or don't and each file will be its own module.
* Custom log strings - Customize what your log should look like. The current default is very verbose, including timestamp, module, and dispatch queue or thread.
* Custom filters - Place a filter over your logs so that only certain ones come through. Filter by string or regex.
* Fully Asynchronous - Everything takes place on a background thread except for error level messages. Those come through synchronously so you have them before you crash.
* Log in release or debug - Set certain loggers to only run if Xcode is in DEBUG mode, which is hugely useful for file and web loggers.
* Pretty good testing - Unit tests are written for large portions of the library.
