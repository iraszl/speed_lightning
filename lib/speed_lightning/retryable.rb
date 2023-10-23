module SpeedLightning
  module Retryable

    def with_retry
      should_retry = true
      begin
        yield
      rescue SpeedLightning::Error => e
        if should_retry
          should_retry = false
          sleep 1
          retry
        else
          raise e
        end
      end
    end

  end
end