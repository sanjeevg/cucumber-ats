module Retriable
  # This will catch any exception and retry twice (three tries total):
  #   with_retries { ... }
  #
  # This will catch any exception and retry four times (five tries total):
  #   with_retries(:limit => 5) { ... }
  #
  # This will catch a specific exception and retry once (two tries total):
  #   with_retries(Some::Error, :limit => 2) { ... }
  #
  # You can also sleep inbetween tries. This is helpful if you're hoping
  # that some external service recovers from its issues.
  #   with_retries(Service::Error, :sleep => 1) { ... }
  #
  def with_retries(options={}, &block)
    options[:limit] ||= 5
    options[:sleep] ||= 0
    retried = 0
    begin
      yield
    rescue Exception => e
      if retried + 1 < options[:limit]
        retried += 1
        sleep options[:sleep]
        retry
      else
        raise e
      end
    end
  end
end

World(Retriable)