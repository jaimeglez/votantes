class VoterDocument < ActiveRecord::Base
  validates_presence_of :name, :attachment

  mount_uploader :attachment, AttachmentUploader

  def headers
    document = DocumentReader.new(file_url)
    document.headers
  end

  def import(params)
    byebug
    query = build_comparsion_query(params[:comparison])
    document = DocumentReader.new(file_url)
    document.rows_number.each do |row|
      row_data = document.row_data(row, params[:fields])
      puts row_data
      voter = Voter.where([query, row_data]).first
      if voter.nil?
        byebug
        Voter.create(row_data)
      else
        byebug
        voter.update(row_data)
      end
    end
  end

  def set_imported
    update(imported: true)
  end

  private
    def get_comparison_fields(fields)
      @comparison_fields ||= clean_comparison_fields(fields)
    end

    def clean_comparison_fields(fields)
      comparsion_hash = {}
      fields.each do |key, value|
        clean_value = value.reject(&:empty?)
        comparsion_hash[key] = clean_value unless clean_value.empty?
      end
      comparsion_hash
    end

    def build_comparsion_query(fields)
      comparison_fields = get_comparison_fields(fields)
      query_array = comparison_fields.map do |key, values|
        query = "(("
        blank = "("
        values.each do |value|
          query += "#{value} = :#{value} AND "
          blank += " #{value} <> '' AND "
        end
        query = query[0...-5] + ") AND "+ blank[0...-5] +"))"
      end
      query_array.join(' OR ')
    end

    def file_url
      if Rails.env.development?
        attachment.file.path  
      else
        attachment.file.url  
      end
    end
end
