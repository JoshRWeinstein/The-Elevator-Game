class RidesController < ApplicationController
  
  def update
    @jw = Ride.find(params[:ride_id])
    if (params[:top])
      @jw[:top] = true
    else
      @jw[:top] = false
    end
    session[:last] = @jw[:floor] 
    @jw[:timetoclick] = (Time.now - @jw[:created_at])
    session[:timecount] += @jw[:timetoclick]
    session[:ridecount] += 1
    session[:floorcount] += @jw[:floor]
    @sesh = Usersession.find(session[:seshid])
    @sesh[:rides] = session[:ridecount]
    @sesh[:time] = session[:timecount]
    @sesh[:floors] = session[:floorcount]
    @sesh[:config] = session[:config]
    @sesh.save
    @jw.save
    redirect_to root_url
  end
  
  ##setup different configurations 0) lobby top and bottom 1) standard 2) telephone [need to add lobby on bottom!!!]
  ##always 4 rows 5 columns
  def show
    
    @i = 4
    @j = 5

    @lobbyweight = 1 + rand(100)
    if @lobbyweight > 25 || session[:last] == 1
      @floor = 1 + rand(@i*@j)
      while (@floor == session[:last])
        @floor = 1 + rand(@i*@j)
      end
    else
      @floor = 1
    end
    if !session[:seshid]
      @usersesh = Usersession.new
      @usersesh.save
    end
    if !session[:ridecount] || !session[:floorcount] || !session[:timecount] || !session[:config]
      session[:seshid] = @usersesh[:id] 
      session[:ridecount] = 0
      session[:floorcount] = 0
      session[:timecount] = 0
      session[:config] = rand(3)
    end
    @config = session[:config]
    @ridecount = session[:ridecount]
    @floorcount = session[:floorcount]
    @timecount =  session[:timecount]

    @ride = Ride.new
    if session[:last]
      @ride[:last] = session[:last]
    end
    @ride[:session_id] = session[:seshid]
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
  
  def nameentry
    
    if params[:name] != "" && isclean(params[:name].downcase)
      if !session[:seshid]
        @usersesh = Usersession.new
        @usersesh.save
        session[:seshid] = @usersesh[:id]
      end
      @jw = Usersession.find(session[:seshid])
      @jw[:name] = params[:name]
      session[:name] = @jw[:name]
      @jw.save
    end
    redirect_to "/leaders"
  end
  
  
  def isclean(name)
    badwords = ['pussy', 'fuck', 'shit', 'bitch', 'fag', 'homo', 'cock', 'asshole', 'slut', 'whore']
    badwords.each do |x|
      if name.index(x)
        return false
      end
    end  
    return true
  end
  def leaders
  
  @leaders = Usersession.find(:all, :conditions => "rides >= 0", :order => "rides desc, floors desc", :limit => 25)
  @ridecount = session[:ridecount] || 0
  @floorcount = session[:floorcount] || 0
  @name = session[:name]
  end
  
end