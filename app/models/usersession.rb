class Usersession < ActiveRecord::Base
  
  has_many :rides, :foreign_key => :session_id
  
  
  scope :unskilled,
    where('ridecount <= 10 and ridecount IS NOT NULL')
  
  scope :config0,
    where('config = 0')
  
  scope :config2,
    where('config = 2')  
    

  
  def unskilledcount
    self.unskilled.count
  end
end
