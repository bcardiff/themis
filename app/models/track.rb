class Track < ActiveRecord::Base
  validates_presence_of :code

  def css_class
    "track_#{code.downcase}"
  end
end
