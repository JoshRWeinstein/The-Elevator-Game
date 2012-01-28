class RidesController < ApplicationController
  
  def update
    @jw = Ride.find(params[:ride_id])
    @jw[:session_id] = request.session_options[:id]
    @jw.save
    redirect_to root_url
  end
  
  def show

    @i = 4
    @j = 5
    @floor = 1 + rand(@i*@j)
    @ride = Ride.new
    @ride[:rows] = @i
    @ride[:columns] = @j
    @ride[:floor] = @floor
    @ride[:session_id] = session[:current_user_id]
    @ride[:ip_address] = request.remote_ip
    @ride.save
  end
  
  def index
    
  end
    
  
end