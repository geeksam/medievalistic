require 'forwardable'

module Medievalistic
  class App
    extend Forwardable

    def call(env)
      doublemeat_medley = DoublemeatMedley.new(self, env)
      router.dispatch(doublemeat_medley)
      doublemeat_medley.finalize
    end

    def router
      @router ||= Router.new(self)
    end
  end
end
