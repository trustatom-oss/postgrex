# v0.8.0-dev

* Enhancements
  * Add extensions
  * Encode/decode ranges generically
  * Add bounds when encoding integer types to error instead of overflowing the integer

* Backwards incompatible changes
  * Remove the support for type-hinted queries
  * Remove encoder, decoder and formatter functions, use extensions instead
  * Use structs for dates, times, timestamps, interval and ranges

# v0.7.0 (2015-01-20)

* Enhancements
  * Add asynchronous notifications through `listen` and `unlisten`
  * Add support for range types
  * Add support for uuid type
  * Add `:async_connect` option to `start_link/1`

* Bug fixes
  * Fix encoding `nil` values in arrays and composite types

# v0.6.0 (2014-09-07)

* Enhancements
  * Queries can be constructed of `iodata`
  * Support "type hinted" queries to save one client-server round trip which will reduce query latency

* Backwards incompatible changes
  * `Postgrex.Error` `postgres` field is converted from keyword list to map
  * `Postgrex.Connect.query` `params` parameter is no longer optional (pass an empty list if query has no parameters)
  * The `timeout` parameter for all functions have been moved to a keyword list with the key `:timeout`

# v0.5.5 (2014-08-20)

* Enhancements
  * Reduce the amount of intermediary binaries constructed with the help of `iodata`

# v0.5.4 (2014-08-04)

# v0.5.3 (2014-07-13)

# v0.5.2 (2014-06-18)

# v0.5.1 (2014-05-24)

* Backwards incompatible changes
  * `Postgrex.Error` exception converted to struct

# v0.5.0 (2014-05-01)

* Backwards incompatible changes
  * `Postgrex.Result` and `Postgrex.TypeInfo` converted to structs

# v0.4.2 (2014-04-21)

* Enhancements
  * Add timeouts to all synchronous calls. When a timeout is hit an exit error will be raised in the caller process and the connection process will exit
  * Add automatic fallback to environment variables `PGUSER`, `PGHOST` and `PGPASS`

# v0.4.0 (2014-01-16)

* Enhancements
  * Numerics decode and encode to Decimal

# v0.3.1 (2014-01-15)

* Enhancements
  * Compact state before printing to logs and hide password
  * Concurrency support, safe to use connection from multiple processes concurrently

# v0.3.0 (2013-12-16)

* Bug fixes
  * Don't try to decode values of text format

* Backwards incompatible changes
  * Types are stored as binaries instead of atoms, update your custom encoders and decoders


# v0.2.1 (2013-12-10)

* Enhancements
  * Add support for SSL

* Bug fixes
  * Fix decoding of unknown type when using custom decoder


# v0.2.0 (2013-11-14)

* Enhancements
  * Floats handles NaN, inf and -inf
  * Add support for numerics
  * Custom encoders and decoders works on elements in arrays
  * Add support for composite types
  * Add functions that raise on error

* Bug fixes
  * INSERT query works with extended query parameters
  * Return proper `num_rows` on PostgreSQL 8.4
  * Fix race condition

* Backwards incompatible changes
  * Simplify custom decoding and encoding with default function


# v0.1.0 (2013-10-14)

First release!
