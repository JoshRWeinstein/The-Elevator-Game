class Usersession < ActiveRecord::Base
  
  has_many :rides, :foreign_key => :session_id

  scope :trickery,
    where('ridecount >= 500')
      
  scope :cents,
    where('ridecount >= 100 and ridecount < 500')
  
  scope :power,
    where('ridecount >= 50 and ridecount < 100')
  
  scope :skilled,
    where('ridecount >= 21 and ridecount < 50')
  
  scope :unskilled,
    where('ridecount < 21 and ridecount IS NOT NULL')
  
  scope :config0,
    where('config = 0')
  
  scope :config1,
    where('config = 1')
  
  scope :config2,
    where('config = 2')  
    

  
  def unskilledcount
    self.unskilled.count
  end
end
