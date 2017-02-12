require 'open-uri'
require 'tempfile'

module VoterFieldsBuilder
  module One

    def self.parse_and_save_data(file_url)
      @file_url = file_url
      @file_type = File.extname(@file_url)
      case @file_type
      when '.xlsx'
        prepare_xlsx
      when '.csv'
        prepare_csv
      end
      save_data
    end

    private
      def self.replace_quo_char
        text = open("#{@file_url}").read
        new_contents = text.gsub('"', "")
        @tmpfile = Tempfile.new('tmpFile')
        @tmpfile.open
        open(@tmpfile.path, "w") {|file| file.puts new_contents }
        @tmpfile.close
        @tmpfile.path
      end

      def self.prepare_xlsx
        @voter_data = Roo::Excelx.new(@file_url)
        @initial_row = 5
        @headers = @voter_data.row(4)
      end

      def self.prepare_csv
        @voter_data = Roo::CSV.new(replace_quo_char, csv_options: {col_sep: "\;"})
        @initial_row = 1
        # @headers = @voter_data.row(2)
      end

      def self.save_data
        last_row = @voter_data.last_row
        @voter_data.sheets.each do |sheet|
          (@initial_row..last_row).each_slice(1000) do |batch|
            batch.each do |row|
              record = @voter_data.row(row)
              voter = Voter.new(full_name: full_name(record),
                                   address: full_address(record),
                                   electoral_number: record[6],
                                   section: record[0], imported: true)
              if(voter.valid?)
                voter.save
              end
            end
          end
        end
        @tmpfile.unlink
      end

      def self.full_name(record)
        # nombre                                  --11
        # apellido paterno                        --12
        # apellido materno                        --13
        "#{record[11]} #{record[12]} #{record[13]}".squeeze(" ").strip
      end

      def self.full_address(record)
        # calle                                   --17
        # num ext                                 --19
        # num int(opcional)                       --18
        # colonia                                 --20
        # municipio                               --29
        # estado                                  --30
        "#{record[17]} #{record[19]} #{record[18]} #{record[20]} #{record[29]} #{record[30]}".squeeze(" ").strip
      end

  end
end

