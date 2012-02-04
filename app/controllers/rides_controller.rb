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
    
    

    
    #all lobbies
    @A0count = Usersession.config0.count
    @A0 = Usersession.config0.collect {|u| u.rides}.flatten
    @Alobby0 = @A0.select{|u| u[:floor] == 1}.count
    @Alobby0top = @A0.select{|u| u[:top] == true  and u[:timetoclick] <= 10}.count
    @Alobby0notnull = @A0.select{|u| !u[:top].nil? and u[:floor] == 1  and u[:timetoclick] <= 10}.count
    @temp = 0
    @Alobby0notnullavgTTChold = @A0.select{|u| !u[:top].nil? and u[:floor] == 1  and u[:timetoclick] <= 10}.flatten.map{|u| @temp += u[:timetoclick]}
    @Alobby0notnullavgTTC = @temp / @Alobby0notnull
    @Alobby0drops = @Alobby0 - @Alobby0notnull
    
    @A1count = Usersession.config1.count
    @A1 = Usersession.config1.collect {|u| u.rides}.flatten
    @Alobby1 = @A1.select{|u| u[:floor] == 1}.count
    @Alobby1top = @A1.select{|u| u[:top] == true  and u[:timetoclick] <= 10}.count
    @Alobby1notnull = @A1.select{|u| !u[:top].nil? and u[:floor] == 1  and u[:timetoclick] <= 10}.count
    @temp = 0
    @Alobby1notnullavgTTChold = @A1.select{|u| !u[:top].nil? and u[:floor] == 1  and u[:timetoclick] <= 10}.flatten.map{|u| @temp += u[:timetoclick]}
    @Alobby1notnullavgTTC = @temp / @Alobby1notnull
    @Alobby1drops = @Alobby1 - @Alobby1notnull
    
    @A2count = Usersession.config2.count
    @A2 = Usersession.config2.collect {|u| u.rides}.flatten
    @Alobby2 = @A2.select{|u| u[:floor] == 1}.count
    @Alobby2top = @A2.select{|u| u[:top] == true  and u[:timetoclick] <= 10}.count
    @Alobby2notnull = @A2.select{|u| !u[:top].nil? and u[:floor] == 1  and u[:timetoclick] <= 10}.count
    @temp = 0
    @Alobby2notnullavgTTChold = @A2.select{|u| !u[:top].nil? and u[:floor] == 1  and u[:timetoclick] <= 10}.flatten.map{|u| @temp += u[:timetoclick]}
    @Alobby2notnullavgTTC = @temp / @Alobby2notnull
    @Alobby2drops = @Alobby2 - @Alobby2notnull
    
    #meta lobbies
    @Alobby = @Alobby0 + @Alobby1 + @Alobby2
    @Alobbynotnull = @Alobby0notnull + @Alobby1notnull + @Alobby2notnull
    @Alobbydrops = @Alobby0drops + @Alobby1drops + @Alobby2drops
    @Alobbytop = @Alobby0top + @Alobby1top + @Alobby2top
    @AlobbynotnullavgTTC = (@Alobby0notnullavgTTC + @Alobby1notnullavgTTC + @Alobby2notnullavgTTC) / 3
    @Acount = @A0count + @A1count + @A2count
    
    #unskilled lobbies
    @US0count = Usersession.unskilled.config0.count
    @US0 = Usersession.unskilled.config0.collect {|u| u.rides}.flatten
    @USlobby0 = @US0.select{|u| u[:floor] == 1}.count
    @USlobby0top = @US0.select{|u| u[:top] == true  and u[:timetoclick] <= 10}.count
    @USlobby0notnull = @US0.select{|u| !u[:top].nil? and u[:floor] == 1  and u[:timetoclick] <= 10}.count
    @temp = 0
    @USlobby0notnullavgTTChold = @US0.select{|u| !u[:top].nil? and u[:floor] == 1  and u[:timetoclick] <= 10}.flatten.map{|u| @temp += u[:timetoclick]}
    @USlobby0notnullavgTTC = @temp / @USlobby0notnull
    @USlobby0drops = @USlobby0 - @USlobby0notnull
    
    @US1count = Usersession.unskilled.config1.count
    @US1 = Usersession.unskilled.config1.collect {|u| u.rides}.flatten
    @USlobby1 = @US1.select{|u| u[:floor] == 1}.count
    @USlobby1top = @US1.select{|u| u[:top] == true  and u[:timetoclick] <= 10}.count  
    @USlobby1notnull = @US1.select{|u| !u[:top].nil? and u[:floor] == 1  and u[:timetoclick] <= 10}.count
    @temp = 0
    @USlobby1notnullavgTTChold = @US1.select{|u| !u[:top].nil? and u[:floor] == 1  and u[:timetoclick] <= 10}.flatten.map{|u| @temp += u[:timetoclick]}
    @USlobby1notnullavgTTC = @temp / @USlobby1notnull
    @USlobby1drops = @USlobby1 - @USlobby1notnull
    
    @US2count = Usersession.unskilled.config2.count
    @US2 = Usersession.unskilled.config2.collect {|u| u.rides}.flatten
    @USlobby2 = @US2.select{|u| u[:floor] == 1}.count
    @USlobby2top = @US2.select{|u| u[:top] == true  and u[:timetoclick] <= 10}.count
    @USlobby2notnull = @US2.select{|u| !u[:top].nil? and u[:floor] == 1  and u[:timetoclick] <= 10}.count
    @temp = 0
    @USlobby2notnullavgTTChold = @US2.select{|u| !u[:top].nil? and u[:floor] == 1  and u[:timetoclick] <= 10}.flatten.map{|u| @temp += u[:timetoclick]}
    @USlobby2notnullavgTTC = @temp / @USlobby2notnull
    @USlobby2drops = @USlobby2 - @USlobby2notnull
    #meta lobbies
    @USlobby = @USlobby0 + @USlobby1 + @USlobby2
    @USlobbynotnull = @USlobby0notnull + @USlobby1notnull + @USlobby2notnull
    @USlobbydrops = @USlobby0drops + @USlobby1drops + @USlobby2drops
    @USlobbytop = @USlobby0top + @USlobby1top + @USlobby2top
    @USlobbynotnullavgTTC = (@USlobby0notnullavgTTC + @USlobby1notnullavgTTC + @USlobby2notnullavgTTC) / 3
    @UScount = @US0count + @US1count + @US2count
    
    #skilled lobbies
    @S0count = Usersession.skilled.config0.count
    @S0 = Usersession.skilled.config0.collect {|u| u.rides}.flatten
    @Slobby0 = @S0.select{|u| u[:floor] == 1}.count
    @Slobby0top = @S0.select{|u| u[:top] == true  and u[:timetoclick] <= 10}.count
    @Slobby0notnull = @S0.select{|u| !u[:top].nil? and u[:floor] == 1  and u[:timetoclick] <= 10}.count
    @temp = 0
    @Slobby0notnullavgTTChold = @S0.select{|u| !u[:top].nil? and u[:floor] == 1  and u[:timetoclick] <= 10}.flatten.map{|u| @temp += u[:timetoclick]}
    @Slobby0notnullavgTTC = @temp / @Slobby0notnull
    @Slobby0drops = @Slobby0 - @Slobby0notnull
    
    @S1count = Usersession.skilled.config1.count
    @S1 = Usersession.skilled.config1.collect {|u| u.rides}.flatten
    @Slobby1 = @S1.select{|u| u[:floor] == 1}.count
    @Slobby1top = @S1.select{|u| u[:top] == true  and u[:timetoclick] <= 10}.count  
    @Slobby1notnull = @S1.select{|u| !u[:top].nil? and u[:floor] == 1  and u[:timetoclick] <= 10}.count
    @temp = 0
    @Slobby1notnullavgTTChold = @S1.select{|u| !u[:top].nil? and u[:floor] == 1  and u[:timetoclick] <= 10}.flatten.map{|u| @temp += u[:timetoclick]}
    @Slobby1notnullavgTTC = @temp / @Slobby1notnull
    @Slobby1drops = @Slobby1 - @Slobby1notnull
    
    @S2count = Usersession.skilled.config2.count
    @S2 = Usersession.skilled.config2.collect {|u| u.rides}.flatten
    @Slobby2 = @S2.select{|u| u[:floor] == 1}.count
    @Slobby2top = @S2.select{|u| u[:top] == true  and u[:timetoclick] <= 10}.count
    @Slobby2notnull = @S2.select{|u| !u[:top].nil? and u[:floor] == 1  and u[:timetoclick] <= 10}.count
    @temp = 0
    @Slobby2notnullavgTTChold = @S2.select{|u| !u[:top].nil? and u[:floor] == 1  and u[:timetoclick] <= 10}.flatten.map{|u| @temp += u[:timetoclick]}
    @Slobby2notnullavgTTC = @temp / @Slobby2notnull
    @Slobby2drops = @Slobby2 - @Slobby2notnull
    #meta lobbies
    @Slobby = @Slobby0 + @Slobby1 + @Slobby2
    @Slobbynotnull = @Slobby0notnull + @Slobby1notnull + @Slobby2notnull
    @Slobbydrops = @Slobby0drops + @Slobby1drops + @Slobby2drops
    @Slobbytop = @Slobby0top + @Slobby1top + @Slobby2top
    @SlobbynotnullavgTTC = (@Slobby0notnullavgTTC + @Slobby1notnullavgTTC + @Slobby2notnullavgTTC) / 3
    @Scount = @S0count + @S1count + @S2count
    
    #power lobbies
    @P0count = Usersession.power.config0.count
    @P0 = Usersession.power.config0.collect {|u| u.rides}.flatten
    @Plobby0 = @P0.select{|u| u[:floor] == 1}.count
    @Plobby0top = @P0.select{|u| u[:top] == true  and u[:timetoclick] <= 10}.count
    @Plobby0notnull = @P0.select{|u| !u[:top].nil? and u[:floor] == 1  and u[:timetoclick] <= 10}.count
    @temp = 0
    @Plobby0notnullavgTTChold = @P0.select{|u| !u[:top].nil? and u[:floor] == 1  and u[:timetoclick] <= 10}.flatten.map{|u| @temp += u[:timetoclick]}
    @Plobby0notnullavgTTC = @temp / @Plobby0notnull
    @Plobby0drops = @Plobby0 - @Plobby0notnull
    
    @P1count = Usersession.power.config1.count
    @P1 = Usersession.power.config1.collect {|u| u.rides}.flatten
    @Plobby1 = @P1.select{|u| u[:floor] == 1}.count
    @Plobby1top = @P1.select{|u| u[:top] == true  and u[:timetoclick] <= 10}.count  
    @Plobby1notnull = @P1.select{|u| !u[:top].nil? and u[:floor] == 1  and u[:timetoclick] <= 10}.count  
    @temp = 0
    @Plobby1notnullavgTTChold = @P1.select{|u| !u[:top].nil? and u[:floor] == 1  and u[:timetoclick] <= 10}.flatten.map{|u| @temp += u[:timetoclick]}
    @Plobby1notnullavgTTC = @temp / @Plobby1notnull
    @Plobby1drops = @Plobby1 - @Plobby1notnull
    
    @P2count = Usersession.power.config2.count
    @P2 = Usersession.power.config2.collect {|u| u.rides}.flatten
    @Plobby2 = @P2.select{|u| u[:floor] == 1}.count
    @Plobby2top = @P2.select{|u| u[:top] == true  and u[:timetoclick] <= 10}.count
    @Plobby2notnull = @P2.select{|u| !u[:top].nil? and u[:floor] == 1  and u[:timetoclick] <= 10}.count
    @temp = 0
    @Plobby0notnullavgTTChold = @P2.select{|u| !u[:top].nil? and u[:floor] == 1  and u[:timetoclick] <= 10}.flatten.map{|u| @temp += u[:timetoclick]}
    @Plobby2notnullavgTTC = @temp / @Plobby2notnull
    
    @Plobby2drops = @Plobby2 - @Plobby2notnull
    #meta lobbies
    @Plobby = @Plobby0 + @Plobby1 + @Plobby2
    @Plobbynotnull = @Plobby0notnull + @Plobby1notnull + @Plobby2notnull
    @Plobbydrops = @Plobby0drops + @Plobby1drops + @Plobby2drops
    @Plobbytop = @Plobby0top + @Plobby1top + @Plobby2top
    @PlobbynotnullavgTTC = (@Plobby0notnullavgTTC + @Plobby1notnullavgTTC + @Plobby2notnullavgTTC) / 3
    @Pcount = @P0count + @P1count + @P2count
    
    #cents lobbies
    @C0count = Usersession.cents.config0.count
    @C0 = Usersession.cents.config0.collect {|u| u.rides}.flatten
    @Clobby0 = @C0.select{|u| u[:floor] == 1}.count
    @Clobby0top = @C0.select{|u| u[:top] == true  and u[:timetoclick] <= 10}.count
    @Clobby0notnull = @C0.select{|u| !u[:top].nil? and u[:floor] == 1  and u[:timetoclick] <= 10}.count
    @temp = 0
    @Clobby0notnullavgTTChold = @C0.select{|u| !u[:top].nil? and u[:floor] == 1  and u[:timetoclick] <= 10}.flatten.map{|u| @temp += u[:timetoclick]}
    @Clobby0notnullavgTTC = @temp / @Clobby0notnull
    @Clobby0drops = @Clobby0 - @Clobby0notnull
    
    @C1count = Usersession.cents.config1.count
    @C1 = Usersession.cents.config1.collect {|u| u.rides}.flatten
    @Clobby1 = @C1.select{|u| u[:floor] == 1}.count
    @Clobby1top = @C1.select{|u| u[:top] == true  and u[:timetoclick] <= 10}.count  
    @Clobby1notnull = @C1.select{|u| !u[:top].nil? and u[:floor] == 1  and u[:timetoclick] <= 10}.count
    @temp = 0
    @Clobby1notnullavgTTChold = @C1.select{|u| !u[:top].nil? and u[:floor] == 1  and u[:timetoclick] <= 10}.flatten.map{|u| @temp += u[:timetoclick]}
    @Clobby1notnullavgTTC = @temp / @Clobby1notnull
    @Clobby1drops = @Clobby1 - @Clobby1notnull
    
    @C2count = Usersession.cents.config2.count
    @C2 = Usersession.cents.config2.collect {|u| u.rides}.flatten
    @Clobby2 = @C2.select{|u| u[:floor] == 1}.count
    @Clobby2top = @C2.select{|u| u[:top] == true  and u[:timetoclick] <= 10}.count
    @Clobby2notnull = @C2.select{|u| !u[:top].nil? and u[:floor] == 1  and u[:timetoclick] <= 10}.count
    @temp = 0
    @Clobby2notnullavgTTChold = @C2.select{|u| !u[:top].nil? and u[:floor] == 1  and u[:timetoclick] <= 10}.flatten.map{|u| @temp += u[:timetoclick]}
    @Clobby2notnullavgTTC = @temp / @Clobby2notnull
    @Clobby2drops = @Clobby2 - @Clobby2notnull
    #meta lobbies
    @Clobby = @Clobby0 + @Clobby1 + @Clobby2
    @Clobbynotnull = @Clobby0notnull + @Clobby1notnull + @Clobby2notnull
    @Clobbydrops = @Clobby0drops + @Clobby1drops + @Clobby2drops
    @Clobbytop = @Clobby0top + @Clobby1top + @Clobby2top
    @ClobbynotnullavgTTC = (@Clobby0notnullavgTTC + @Clobby1notnullavgTTC + @Clobby2notnullavgTTC) / 3
    @Ccount = @C0count + @C1count + @C2count
    
    #trickery lobbies
    @T0count = Usersession.trickery.config0.count
    @T0 = Usersession.trickery.config0.collect {|u| u.rides}.flatten
    @Tlobby0 = @T0.select{|u| u[:floor] == 1}.count
    @Tlobby0top = @T0.select{|u| u[:top] == true  and u[:timetoclick] <= 10}.count
    @Tlobby0notnull = @T0.select{|u| !u[:top].nil? and u[:floor] == 1  and u[:timetoclick] <= 10}.count
    @temp = 0
    @Tlobby0notnullavgTTChold = @T0.select{|u| !u[:top].nil? and u[:floor] == 1  and u[:timetoclick] <= 10}.flatten.map{|u| @temp += u[:timetoclick]}
    @Tlobby0notnullavgTTC = @temp / @Tlobby0notnull
    @Tlobby0drops = @Tlobby0 - @Tlobby0notnull
    
    @T1count = Usersession.trickery.config1.count
    @T1 = Usersession.trickery.config1.collect {|u| u.rides}.flatten
    @Tlobby1 = @T1.select{|u| u[:floor] == 1}.count
    @Tlobby1top = @T1.select{|u| u[:top] == true  and u[:timetoclick] <= 10}.count  
    @Tlobby1notnull = @T1.select{|u| !u[:top].nil? and u[:floor] == 1  and u[:timetoclick] <= 10}.count
    @temp = 0
    @Tlobby1notnullavgTTChold = @T1.select{|u| !u[:top].nil? and u[:floor] == 1  and u[:timetoclick] <= 10}.flatten.map{|u| @temp += u[:timetoclick]}
    @Tlobby1notnullavgTTC = @temp / @Tlobby1notnull
    @Tlobby1drops = @Tlobby1 - @Tlobby1notnull
    
    @T2count = Usersession.trickery.config2.count
    @T2 = Usersession.trickery.config2.collect {|u| u.rides}.flatten
    @Tlobby2 = @T2.select{|u| u[:floor] == 1}.count
    @Tlobby2top = @T2.select{|u| u[:top] == true  and u[:timetoclick] <= 10}.count
    @Tlobby2notnull = @T2.select{|u| !u[:top].nil? and u[:floor] == 1  and u[:timetoclick] <= 10}.count
    @temp = 0
    @Tlobby2notnullavgTTChold = @T2.select{|u| !u[:top].nil? and u[:floor] == 1  and u[:timetoclick] <= 10}.flatten.map{|u| @temp += u[:timetoclick]}
    @Tlobby2notnullavgTTC = @temp / @Tlobby2notnull
    @Tlobby2drops = @Tlobby2 - @Tlobby2notnull
    #meta lobbies
    @Tlobby = @Tlobby0 + @Tlobby1 + @Tlobby2
    @Tlobbynotnull = @Tlobby0notnull + @Tlobby1notnull + @Tlobby2notnull
    @Tlobbydrops = @Tlobby0drops + @Tlobby1drops + @Tlobby2drops
    @Tlobbytop = @Tlobby0top + @Tlobby1top + @Tlobby2top
    @TlobbynotnullavgTTC = (@Tlobby0notnullavgTTC + @Tlobby1notnullavgTTC + @Tlobby2notnullavgTTC) / 3
    @Tcount = @T0count + @T1count + @T2count
  end
end