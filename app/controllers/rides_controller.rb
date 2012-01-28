class RidesController < ApplicationController
  
  def update
    @jw = Ride.find(params[:ride_id])
    if (params[:top])
      @jw[:top] = true
    else
      @jw[:top] = false
    end
    
    @jw[:timetoclick] = (Time.now - @jw[:created_at]).round
    session[:timecount] += @jw[:timetoclick]
    session[:ridecount] += 1
    session[:floorcount] += @jw[:floor]
    
    @jw.save
    redirect_to root_url
  end
  
  ##setup different configurations 0) lobby top and bottom 1) standard 2) telephone
  ##always 4 rows 5 columns
  def show


    @config = rand(3)
    @i = 4
    @j = 5

    @lobbyweight = 1 + rand(100)
    if @lobbyweight > 25
      @floor = 1 + rand(@i*@j)
    else
      @floor = 1
    end
    if !session[:ridecount] || !session[:floorcount] || !session[:timecount]
      session[:ridecount] = 0
      session[:floorcount] = 0
      session[:timecount] = 0
    end


    @ridecount = session[:ridecount]
    @floorcount = session[:floorcount]
    @timecount =  session[:timecount]



    @ride = Ride.new
    @ride[:session_id] = request.session_options[:id]
    @ride[:config] = @config
    @ride[:rows] = @i
    @ride[:columns] = @j
    @ride[:floor] = @floor

    @ride[:ip_address] = request.remote_ip
    @ride.save
  end
  
  def index
    
  end
  
  def configs
  
  end  
  
end