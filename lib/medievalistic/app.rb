require 'forwardable'

module Medievalistic
  class App
    extend Forwardable

    # TODO: nail this behavior down with a test
    # (In fact, this whole class is only exercised by the integration test.  Which may be okay.)
    def self.inherited(subclass)
      set_root_path_on_descendant subclass
    end

    def self.set_root_path_on_descendant(subclass)
      subclass_defined_in = caller[1]
      file = subclass_defined_in.split(':').first
      path = File.expand_path(File.dirname(file))
      subclass.const_set :Root, path
    end

    def call(env)
      doublemeat_medley = DoublemeatMedley.new(self, env)
      router.dispatch(doublemeat_medley)
      doublemeat_medley.finalize
    end

    def router
      @router ||= Router.new(self)
    end

    def root
      @root ||= File.expand_path(self.class::Root)
    end
  end
end
