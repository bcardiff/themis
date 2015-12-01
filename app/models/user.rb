class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  belongs_to :teacher
  belongs_to :place

  delegate :cashier?, to: :teacher, allow_nil: true

  def teacher?
    !teacher.nil? && teacher.fee > 0
  end

  def place?
    !place.nil?
  end

  def can_access_room_area?
    admin? || cashier?
  end
end
