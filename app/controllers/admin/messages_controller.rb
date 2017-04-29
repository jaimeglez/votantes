class Admin::MessagesController < Admin::AdminBaseController
  def index
    @messages = Message.all
    @messages = @messages.page(params[:page]).per(10)
  end

  def new
    @message = Message.new
  end

  def create
    @message = Message.new(message_permit)
    if @message.save
      flash.now[:success] = 'Se creó el mensaje satisfactoriamente'
      redirect_to admin_messages_path
    else
      flash.now[:danger] = 'Hubo un error al crear el mensaje'
      render :new
    end
  end

   private
   def message_permit
     params.require(:message).permit(:msg_type, :content_video, :content_text, :group_type,
                                     zones_ids: [], sections_ids: [], squares_ids: [])
   end
end
