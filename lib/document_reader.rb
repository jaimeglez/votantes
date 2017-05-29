class DocumentReader
  def initialize(path)
    @book = Roo::Spreadsheet.open(path)
  end

  def book
    @book
  end

  def headers
    @headers ||= @book.sheet(0).row(1)
  end

  def row_data(position, row_order)
    import_headers = clean_import_headers(row_order)
    row = {}
    import_headers.each do |key, value|
      tmp_value = []
      value.each do |field|
        tmp_value << @book.row(position)[header_position(field)]
      end 
      row[key.to_sym] = tmp_value.join(' ') 
    end
    row
  end

  def rows_number
    ((@book.first_row + 1)..@book.last_row)
  end

  private
    def get_import_headers(row_order)
      headers = {}
      row_order.each do |key, value|
        clean_value = value.reject(&:empty?)
        headers[key] = clean_value unless clean_value.empty?
      end
      headers
    end

    def header_position(header)
      headers.index(header)
    end

    def get_value(position, header)
      row_data(position)[header_position(header)]
    end

    def clean_import_headers(row_order = nil)
      @import_headers ||= get_import_headers(row_order)
    end
end