# Stubbornly

Stubbornly retries a given block until the maximum number of attempts or timeout has been reached.

## Example

```ruby
require 'stubbornly'
require 'http'
require 'logger'

class Checker
  def initialize(url)
    @url = url
    @logger = Logger.new(STDOUT)
    @stubbornly = Stubbornly.new(logger: @logger)
  end

  def up?
    @stubbornly.retry(timeout: 3) do
      HTTP.get(@url)
    end
  end
end

if Checker.new('http://localhost:8765').up?
  puts "Website is up"
else
  warn "We are DOWN!"
end
```

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
