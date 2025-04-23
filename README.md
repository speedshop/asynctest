# Parallel HTTP

A bakeoff between `Async` and `concurrent-ruby` for making parallel HTTP requests with different concurrency implementations.

## Features

- Make multiple HTTP requests in parallel
- Limit concurrent connections
- Two implementations:
  - `async`: Uses the `async` gem with fibers
  - `concurrent`: Uses `concurrent-ruby` with threads
- Simple, consistent interface across implementations

## Usage

```sh
IMPLEMENTATION=async bin/test
IMPLEMENTATION=concurrent bin/test
```

## License

MIT
