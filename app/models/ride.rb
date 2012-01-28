class Ride < ActiveRecord::Base
  attr_accessor :rows, :columns, :floor, :session_id, :ip_address
end
