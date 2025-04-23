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

We're testing an interface that looks like this:

```ruby
module Parallel
  # For each thing you want to do in parallel, you subclass Parallel::Base
  # and define the task as fetch(args), where args is just a Hash.
  class HTTP < Base
    def fetch(args) = Net::HTTP.get(URI(args[:url]))
  end
end

service = Parallel::HTTP.new
service.add_work(url: "https://google.com")
service.add_work(url: "https://yahoo.com")
results = service.fetch_all
# results is an Array with each HTTP.get() response in it
```

## License

MIT
