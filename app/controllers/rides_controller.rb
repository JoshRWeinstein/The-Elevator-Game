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
    @sesh[:ridecount] = session[:ridecount]
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
    session[:last] = 0 
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
  
  @leaders = Usersession.find(:all, :conditions => "ridecount >= 0", :order => "ridecount desc, floors desc", :limit => 25)
  @ridecount = session[:ridecount] || 0
  @floorcount = session[:floorcount] || 0
  @name = session[:name]
  end
  
  def results
    #@Usersession = Usersession.all
    #@UsersessionCount = Usersession.count
    #@Ride = Ride.all
    #@RidesCount = Ride.count
    @lobby0 = Ride.find(:all, :conditions => "config = 0 and floor = 1").count
    @lobby0top = Ride.find(:all, :conditions => "top = true and config = 0 ").count
    @lobby0notnull =Ride.find(:all, :conditions => "top IS NOT NULL and config = 0 and floor = 1").count
    @lobby2 = Ride.find(:all, :conditions => "config = 2 and floor = 1").count
    @lobby2top = Ride.find(:all, :conditions => "config = 2 and floor = 1 and top = true").count
    @lobby2notnull = Ride.find(:all, :conditions => "top IS NOT NULL and config = 2 and floor = 1").count
    
    
    @US0 = Usersession.unskilled.config0.collect {|u| u.rides}.flatten
    @USlobby0 = @US0.select{|u| u[:floor] == 1}.count
    @USlobby0top = @US0.select{|u| u[:top] == true}.count
    @USlobby0notnull = @US0.select{|u| u[:top] and u[:floor] == 1}.count
    
    @US2 = Array.new(Usersession.unskilled.config2.collect {|u| u.rides}.flatten)
    @USlobby2 = @US2.select{|u| u[:floor] == 1}.count
    @USlobby2top = @US2.select{|u| u[:top] == true}.count
    @USlobby2notnull = @US2.select{|u| u[:top] and u[:floor] == 1}.count
    
  end
end