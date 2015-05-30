module ActiveRecord
  class Relation
    def first_or_build(attributes)
      (where(attributes).first || build(attributes)).tap do |res|
        # byebug
        proxy_association.push res #.add_to_target(object) if object.new_record?
      end
    end
  end
end
