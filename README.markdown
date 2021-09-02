# Stubbornly

[![Build Status](https://app.travis-ci.com/suhlig/stubbornly.svg?branch=master)](https://app.travis-ci.com/suhlig/stubbornly)

`Stubbornly` retries a given block until the maximum number of attempts or a timeout has been reached.

The timeout is enforced right *before* an attempt, but if that blocks longer than the given `timeout` it will not be interrupted. Instead of using the [dangerous `Timeout` module](http://www.mikeperham.com/2015/05/08/timeout-rubys-most-dangerous-api/),  use a library that fails fast and retry multiple times using `Stubbornly`.

## Examples

### Timeout

```ruby
require 'stubbornly'
require 'http'

class Checker
  def initialize(url)
    @url = url
    @stubbornly = Stubbornly.new
  end

  def up?
    @stubbornly.retry(timeout: 3) do
      HTTP.get(@url)
    end
  end
end

begin
  Checker.new('http://localhost:8765').up?
rescue => e
  warn "Error: #{e.message}"
end
```

### Maximum number of attempts

```ruby
require 'stubbornly'
require 'http'

class Checker
  def initialize(url)
    @url = url
    @stubbornly = Stubbornly.new
  end

  def up?
    @stubbornly.retry(attempts: 3) do
      response = HTTP.get(@url)
      puts "The site at #{@url} is up 👍"
    end
  end
end

begin
  Checker.new('http://localhost:8765').up?
rescue => e
  warn "Error: #{e.message}"
end
```

## Alternatives

* [retriable](https://github.com/kamui/retriable)

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
