class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  belongs_to :teacher
  belongs_to :place

  delegate :cashier?, to: :teacher

  def teacher?
    !teacher.nil?
  end

  def place?
    !place.nil?
  end
end
