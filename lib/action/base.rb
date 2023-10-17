module Action
  class Base
    def call
      raise 'Action not allowed' unless can?

      perform
    end
  end
end
