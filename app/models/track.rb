class Track < ActiveRecord::Base
  validates_presence_of :code

  def css_prefix
    "#{code[0..1].downcase} #{code.downcase}"
  end
end
