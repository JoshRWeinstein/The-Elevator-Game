class Ride < ActiveRecord::Base
  attr_accessor :rows, :columns, :floor, :session_id, :ip_address, :config
  
  
  belongs_to :usersession, :foreign_key => :id
  
  scope :lobby,
    where('floor = 1')
  
  scope :top,
    where('top = true')
  
  scope :notnull,
    where('top IS NOT NULL')
    
end
