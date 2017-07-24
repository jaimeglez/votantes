class Admin::NotesController < Admin::AdminBaseController
  before_action :search_form, only: :index

  def index
    @voters = Voter.all
    set_noter_type
    @notes = Note.build_search(params[:q]).includes(:voter).order('created_at').page(params[:page])
  end

  private
    def search_form
      @q = params[:q] ||= {}
    end

    def set_noter_type
      params[:q][:note_type] ||= params[:note_type]
      params[:note_type] ||= params[:q][:note_type]
    end
end
