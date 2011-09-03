module Topcgen
  class Safe
    def self.run *error_messages
      begin
        yield
      rescue Exception => e
        $log.error e.message
        $log.error e.backtrace.inspect
        error_messages.each do |m|
          $log.error m
        end
        raise e
      end
    end
  end
end
