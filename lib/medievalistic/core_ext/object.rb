unless Object.new.respond_to?(:tap)
  class Object
    def tap
      yield self
      return self
    end
  end
end


unless Object.new.respond_to?(:blank?)
  class Object
    def blank?
      respond_to?(:empty?) ? !!empty? : !self
    end
  end
  class Object
    def present?
      !blank?
    end
  end
end
