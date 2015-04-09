class RoomsController < ApplicationController
  before_filter :config_opentok,:except => [:index]

  def index
    @rooms = Room.where(:public=> true).order("created_at_DESC")
    @new_room = Room.new
  end

  def create
    session = @opentok.create_session request.remote_addr
    params[:room][:session_id] = session.session_id

    @new_room = Room.new(params[:room])

    respond_to do |format|
      if @new_room.save
        format.html {redirect_to("/party" + @new_room.id.to_s)}
      else
        format.html{render :controller => 'rooms', :action => "index"}
      end
    end
  end

  def party
    @room = Room.find(params[:id])
    @tok_token = @opentok.generate_token :session_id => @room.session_id
  end

  private
  def config_opentok
    if @opentok.nil?
      @opentok::OpenTok.new 45206182, 09ffb68df09869c47f89039b8c86fc2925abff2f
    end
  end

end
