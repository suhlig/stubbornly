# frozen_string_literal: true

require 'null_logger'
require 'English'

class Stubbornly
  #
  # Constructs a new `Stubbornly` instance.
  #
  # If a block is passed, it will be called to calculate the sleep time (in
  # seconds) before the next attempt is made. The attempt counter is passed
  # as a block argument.
  #
  # This is useful to determine the backoff characteristics. The result of the
  # block will be the sleep time in seconds. For instance, the following code
  # would implement an exponential backoff with retries after 1, 3, 7, 15,
  # 31, ... seconds:
  #
  #   Stubbornly.new {|attempt| 2**attempt - 1 }
  #
  # The default backoff is 1 (constant), i.e. the attempts are equidistant at 1s.
  #
  def initialize(logger: NullLogger.new, &block)
    @logger = logger
    @backoff = block || proc { 1 }
  end

  #
  # Calls the given block, rescuing its errors, and retries until either the
  # given timeout or the maximum number of attempts was exceeded.
  #
  # When an attempt raises an error, this method will sleep before it retries.
  # The number of seconds to sleep is determined by the block passed to {#initialize}.
  #
  # If the block succeeds, its value is returned.
  #
  def retry(timeout: Float::INFINITY, attempts: Float::INFINITY, &block)
    @logger.debug("Attempting not more than #{attempts} times") unless attempts.infinite?
    @logger.debug("Will time out after #{timeout}s") unless timeout.infinite?

    attempt = 1
    start = Time.now

    begin
      @logger.info "Attempt ##{attempt} #{after_elapsed_since(start)}"

      if block
        yield(attempt, elapsed_since(start)).tap do
          @logger.info "Success #{after_elapsed_since(start)} and #{attempt} attempts"
        end
      end
    rescue StandardError => e
      @logger.warn e.message

      if attempt >= attempts
        @logger.error "Maximum number of attempts (#{attempts}) reached (#{after_elapsed_since(start)})"
        raise
      end

      # TODO: Give up NOW if retry_after would exceed timeout

      if elapsed_since(start) >= timeout
        @logger.info "Timed out #{after_elapsed_since(start)} (#{attempt} attempts)"
        raise
      end

      attempt += 1
      retry_after = @backoff.call(attempt)

      @logger.warn "Trying again in #{retry_after}s."
      sleep(retry_after)
      retry
    end
  end

  private

  def elapsed_since(start)
    Time.now - start
  end

  def after_elapsed_since(start)
    "after #{elapsed_since(start).round(2)}s"
  end
end
