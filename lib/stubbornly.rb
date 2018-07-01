# frozen_string_literal: true

require 'null_logger'
require 'English'

class Stubbornly
  def initialize(logger: NullLogger.new)
    @logger = logger
  end

  def retry(timeout: Float::INFINITY, attempts: Float::INFINITY)
    @logger.debug("Attempting not more than #{attempts} times") unless attempts.infinite?
    @logger.debug("Will time out after #{timeout}s") unless timeout.infinite?

    attempt = 1
    start = Time.now

    begin
      @logger.info "Attempt ##{attempt} #{after_elapsed_since(start)}"
      yield.tap do
        @logger.info "Success #{after_elapsed_since(start)} and #{attempt} attempts"
      end
    rescue StandardError => error
      @logger.warn error.message

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
      retry_after = 2**attempt - 1

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
