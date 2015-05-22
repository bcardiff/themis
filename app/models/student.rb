class Student < ActiveRecord::Base
  validates_presence_of :first_name
   #TODO uniq card, email
end
