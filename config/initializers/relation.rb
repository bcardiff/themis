module ActiveRecord
  class Relation
    def first_or_build(attributes)
      where(attributes).first || build(attributes)
    end
  end
end
