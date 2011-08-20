unless String.instance_methods.include?(:blank?)
  class String
    def blank?
      match(/^\s*$/) || super
    end
  end
end
