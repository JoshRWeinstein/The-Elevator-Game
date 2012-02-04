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
    
    #filtering out times > 10s
    @Atype = "All"
    @UStype = "Unskilled: <10"
    @Stype = "Skilled: 10-20"
    @Ptype = "Power: 21-50"
    @Ctype = "Superpower: 50-300"
    @Ttype = "Gamers: 300+"
    @Ascope = "" 
    @USscope = ".unskilled"
    @Sscope = ".skilled"
    @Pscope = ".power"
    @Cscope = ".cents"
    @Tscope = ".trickery"
    
    @buckets = ['A', 'US', 'S', 'P', 'C', 'T']
    
    @buckets.each do |x|
      (0..2).each do |jw|
        eval("@#{x}#{jw}count = Usersession#{eval("@#{x}scope")}.config#{jw}.count
        @#{x}#{jw} = Usersession#{eval("@#{x}scope")}.config#{jw}.collect {|u| u.rides}.flatten
        @#{x}lobby#{jw} = @#{x}#{jw}.select{|u| u[:floor] == 1}.count
        @#{x}lobby#{jw}top = @#{x}#{jw}.select{|u| u[:top] == true  and u[:timetoclick] <= 10}.count
        @#{x}lobby#{jw}notnull = @#{x}#{jw}.select{|u| !u[:top].nil? and u[:floor] == 1  and u[:timetoclick] <= 10}.count
        @temp = 0
        @#{x}lobby#{jw}notnullavgTTChold = @#{x}#{jw}.select{|u| !u[:top].nil? and u[:floor] == 1  and u[:timetoclick] <= 5}.flatten.map{|u| @temp += u[:timetoclick]}
        @#{x}lobby#{jw}notnullavgTTC = @temp / @#{x}lobby#{jw}notnull
        @#{x}lobby#{jw}drops = @#{x}lobby#{jw} - @#{x}lobby#{jw}notnull")
        if jw % 2 == 0
          eval("@temp=0
          @#{x}lobby#{jw}notnullavgBTTChold = @#{x}#{jw}.select{|u| u[:top] == true and u[:timetoclick] <= 5}.flatten.map{|u| @temp += u[:timetoclick]}
          @#{x}lobby#{jw}notnullavgBTTC = @temp / @#{x}lobby#{jw}top")
        end  
      end
      eval("@#{x}lobby = @#{x}lobby0 + @#{x}lobby1 + @#{x}lobby2
      @#{x}lobbynotnull = @#{x}lobby0notnull + @#{x}lobby1notnull + @#{x}lobby2notnull
      @#{x}lobbydrops = @#{x}lobby0drops + @#{x}lobby1drops + @#{x}lobby2drops
      @#{x}lobbytop = @#{x}lobby0top + @#{x}lobby1top + @#{x}lobby2top
      @#{x}lobbynotnullavgTTC = (@#{x}lobby0notnullavgTTC + @#{x}lobby1notnullavgTTC + @#{x}lobby2notnullavgTTC) / 3
      @#{x}count = @#{x}0count + @#{x}1count + @#{x}2count")

    end
  ##########################################
  #          NOT LOBBY
  ##########################################
    @buckets.each do |x|
      (0..2).each do |jw|
        eval("@#{x}#{jw}count = Usersession#{eval("@#{x}scope")}.config#{jw}.count
        @#{x}#{jw} = Usersession#{eval("@#{x}scope")}.config#{jw}.collect {|u| u.rides}.flatten
        @#{x}notlob#{jw} = @#{x}#{jw}.select{|u| u[:floor] == 1}.count
        @#{x}notlob#{jw}top = @#{x}#{jw}.select{|u| u[:top] == true  and u[:timetoclick] <= 10}.count
        @#{x}notlob#{jw}notnull = @#{x}#{jw}.select{|u| !u[:top].nil? and u[:floor] == 1  and u[:timetoclick] <= 10}.count
        @temp = 0
        @#{x}notlob#{jw}notnullavgTTChold = @#{x}#{jw}.select{|u| !u[:top].nil? and u[:floor] == 1  and u[:timetoclick] <= 5}.flatten.map{|u| @temp += u[:timetoclick]}
        @#{x}notlob#{jw}notnullavgTTC = @temp / @#{x}notlob#{jw}notnull
        @#{x}notlob#{jw}drops = @#{x}notlob#{jw} - @#{x}notlob#{jw}notnull")
      end
      eval("@#{x}notlob = @#{x}notlob0 + @#{x}notlob1 + @#{x}notlob2
      @#{x}notlobnotnull = @#{x}notlob0notnull + @#{x}notlob1notnull + @#{x}notlob2notnull
      @#{x}notlobdrops = @#{x}notlob0drops + @#{x}notlob1drops + @#{x}notlob2drops
      @#{x}notlobtop = @#{x}notlob0top + @#{x}notlob1top + @#{x}notlob2top
      @#{x}notlobnotnullavgTTC = (@#{x}notlob0notnullavgTTC + @#{x}notlob1notnullavgTTC + @#{x}notlob2notnullavgTTC) / 3
      @#{x}count = @#{x}0count + @#{x}1count + @#{x}2count")
    end
    
    @ridecountbucket = 0
    #@jw2 = Usersession.all
    #@jw2.each do |z|
      #if z[:ridecount]
        #@ridecountbucket[eval("z[:ridecount]")] +=1
      #end
    #end
    

  end
end