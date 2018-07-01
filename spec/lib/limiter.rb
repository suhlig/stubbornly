# frozen_string_literal: true

class Limiter
  BeyondLimit = Class.new(StandardError) do
    def initialize(limit, actual)
      super("Value #{actual} is beyond the limit #{limit}")
    end
  end

  def initialize(limit)
    @limit = limit
  end

  def limit(number)
    raise BeyondLimit.new(@limit, number) if number > @limit
    number
  end
end
