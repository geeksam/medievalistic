require 'forwardable'

module Medievalistic
  class App
    extend Forwardable

    def_delegator :router, :call
    def router
      @router ||= Router.new
    end
  end
end
