module MoneyMover
  module Dwolla
    class ErrorHandler
      def initialize(server_error)
        @server_error = server_error
        @errors = StandaloneErrors.new
      end

      def errors
        @errors.clear

        if @server_error[:_embedded]
          @server_error[:_embedded][:errors].each do |error|
            if error[:path]
              key = error[:path].split('/')[1].to_sym
            else
              key = :base
            end

            @errors.add key, error[:message]
          end
        else
          @errors.add :base, @server_error[:message]
        end

        @errors
      end
    end
  end
end
