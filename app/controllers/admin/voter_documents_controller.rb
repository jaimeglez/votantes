class Admin::VoterDocumentsController < Admin::AdminBaseController
  def index
    @voter_documents = VoterDocument.page(params[:page])
  end

  def new
    @voter_document = VoterDocument.new
  end

  def create
    @voter_document = VoterDocument.new(document_params)
    byebug
    if @voter_document.save
       flash.now[:success] = 'El documento fue guardado exitosamente'
       redirect_to admin_define_voter_document_import_path(@voter_document.id)
    else
      flash.now[:danger] = 'Hubo un error al crear el documento'
      render :new
    end
  end

  def define_import
    @voter_document = VoterDocument.find(params[:id])
    if @voter_document.imported
      flash.now[:danger] = 'El archivo ya fue importado'
      redirect_to admin_voter_documents_path
    end
    @voter_fields = Voter::IMPORT_FIELDS
    @headers = @voter_document.headers
    @groups = ['group1', 'group2', 'group3', 'group4','group5']
  end 

  def import
    LoadVoterDocumentJob.set(wait: 5.seconds).perform_later(params[:id], params[:document])
    # voter_document = VoterDocument.find(params[:id])
    # voter_document.import(params[:document])
    flash.now[:success] = 'El archivo comenzara a ser importado'
    redirect_to admin_voter_documents_path
  end

  private
    def document_params
      params.require(:voter_document).permit(:name, :attachment)
    end
end
