class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  belongs_to :teacher
  belongs_to :place

  def teacher?
    !teacher.nil?
  end

  def place?
    !place.nil?
  end
end
