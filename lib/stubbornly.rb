# frozen_string_literal: true

require 'null_logger'
require 'English'

class Stubbornly
  def initialize(logger: NullLogger.new)
    @logger = logger
  end

  def retry(timeout: Float::INFINITY, attempts: Float::MAX)
    @logger.debug("Starting first of not more than #{attempts} attempts") if attempts < Float::MAX
    @logger.debug("Will time out after #{timeout}s") unless timeout.infinite?

    attempt = 0
    start = Time.now

    begin
      @logger.info "Attempt ##{attempt}"
      yield.tap do
        @logger.info "Success after #{elapsed_since(start)}s and #{attempt} attempts"
      end
    rescue StandardError
      attempt += 1
      retry_after = 2**attempt - 1
      @logger.warn "#{$ERROR_INFO.message}. Trying again in #{retry_after}s."

      if attempt >= attempts
        @logger.error "Maximum number of attempts (#{attempt}) reached"
        return false
      end

      if elapsed_since(start) >= timeout
        @logger.info "Timed out after #{elapsed_since(start)}s"
        return false
      end

      sleep(retry_after)
      retry
    end
  end

  private

  def elapsed_since(start)
    Time.now - start
  end
end
