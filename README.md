# Parallel HTTP

A bakeoff between `Async` and `concurrent-ruby` for making parallel HTTP requests with different concurrency implementations.

## Features

- Make multiple HTTP requests in parallel
- Limit concurrent connections (5 max)
- Two implementations:
  - `async`: Uses the `async` gem with fibers and barriers for resource cleanup
  - `concurrent`: Uses `concurrent-ruby` with threads and futures
- Simple, consistent interface across implementations

## Usage

```sh
IMPLEMENTATION=async bin/test
IMPLEMENTATION=concurrent bin/test
```

## Implementation Details

### Async Implementation
- Uses Ruby fibers via the `async` gem
- Limits to 5 concurrent connections using `Async::Semaphore`
- Uses `Async::Barrier` for proper resource cleanup
- Lightweight and efficient for I/O-bound operations

### Concurrent Implementation
- Uses Ruby threads via `concurrent-ruby`
- Limits to 5 concurrent connections using `ThreadPoolExecutor`
- Uses `Future` and `CountDownLatch` for synchronization
- Better for CPU-bound operations

## License

MIT
