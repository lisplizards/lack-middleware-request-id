# lack-middleware-request-id

Adds REQUEST-ID to the Lack ENV and X-Request-Id to the response headers.

When the request already has an X-Request-Id header, as when set by an upstream server, the middleware uses that value; otherwise it generates a new request-ID using frugal-uuid.

## Usage

Wrap app:

```common-lisp
(funcall lack/middleware/request-id:*lack-middleware-request-id*
         *app*)
```

Lack Builder:

```common-lisp
(lack/builder:builder
 :request-id
 *app*)
```

## Development

Run tests:

```lisp
(asdf:test-system :foo.lisp.lack-middleware-request-id)
```

## Installation

Not yet in Quicklisp, so for now clone to `local-projects/`.

## Dependencies

### Middleware

* [frugal-uuid](https://github.com/ak-coram/cl-frugal-uuid)

### Tests

* [rove](https://github.com/fukamachi/rove)

## Copyright

Copyright (c) 2024 John Newton

## License

Apache-2.0
