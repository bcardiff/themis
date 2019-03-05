class Track < ActiveRecord::Base
  validates :code, presence: true, uniqueness: true, format: { with: /\A[\w\_]+\z/ }

  def css_class
    "track_#{code.downcase}"
  end
end
