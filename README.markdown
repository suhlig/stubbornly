# Stubbornly

[![Build Status](https://travis-ci.org/suhlig/stubbornly.svg?branch=master)](https://travis-ci.org/suhlig/stubbornly)

Stubbornly retries a given block until the maximum number of attempts or a timeout has been reached.

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

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
