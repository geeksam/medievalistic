module Medievalistic
  class Controller
    attr_reader :request, :response

    def initialize(request, response)
      @request, @response = request, response
    end
    
    def render(*args)
      options = args.pop if args.last.is_a?(Hash)   # Array#extract_options!, anyone?
      if text = options[:text]
        response.headers["Content-Type"] = 'text/plain'
        response.write text
      end
    end
  end
end
