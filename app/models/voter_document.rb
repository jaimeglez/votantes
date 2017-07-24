class VoterDocument < ActiveRecord::Base
  validates_presence_of :name, :attachment

  mount_uploader :attachment, AttachmentUploader

  def headers
    document = DocumentReader.new(attachment.file.url)
    document.headers
  end

  def import(params)
    query = build_comparsion_query(params[:comparison])
    document = DocumentReader.new(attachment.file.url)
    document.rows_number.each do |row|
      row_data = document.row_data(row, params[:fields])
      puts row_data
      voter = Voter.where([query, row_data]).first
      if voter.nil?
        Voter.create(row_data)
      else
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
end
