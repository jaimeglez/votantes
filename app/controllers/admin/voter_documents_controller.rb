class Admin::VoterDocumentsController < Admin::AdminBaseController
  def index
      @voter_documents = VoterDocument.all
   end

   def new
      @voter_document = VoterDocument.new
   end

   def create
      @voter_document = VoterDocument.new(document_params)

      if @voter_document.save
         flash.now[:success] = 'Se creó documento satisfactoriamente'
         redirect_to admin_voter_documents_path
      else
        flash.now[:danger] = 'Hubo un error al crear el documento'
        render :new
      end

   end

   def destroy
     @voter_document = VoterDocument.find(params[:id])
     if @voter_document.destroy
       flash.now[:success] = 'Se eliminó documento satisfactoriamente'
     else
       flash.now[:danger] = 'Hubo un error al eliminar el documento'
     end
     redirect_to admin_voter_documents_path
   end

   private
      def document_params
      params.require(:voter_document).permit(:name, :attachment)
   end
end
