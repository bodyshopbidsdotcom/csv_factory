module CsvFactory
  class Csv
    # Instance variable: @sections
    # Example:
    # [
    #   {
    #     section_name: 'Header',
    #     columns: [
    #       { column_name: 'Record Type' },
    #       { column_name: 'Environment Type' },
    #     ]
    #   },
    #   {
    #     section_name: 'Detail',
    #     columns: [
    #       { column_name: 'Record Type' },
    #       { column_name: 'Business Unit' },
    #       { column_name: 'Claim Number' },
    #     ]
    #   },
    #   {
    #     section_name: 'Trailer',
    #     columns: [
    #       { column_name: 'Record Type' },
    #       { column_name: 'Total Batch File LineItem Count' },
    #       { column_name: 'Total Batch File Amount Total' },
    #     ]
    #   }
    # ]
    #
    # Instance variable: @column_positions
    # A filter and transformation of the @sections information.
    # Example:
    # {
    #   'Header': {
    #     'Record Type': 0,
    #     'Environment Type': 1
    #   },
    #   'Detail': {
    #     'Record Type': 0,
    #     'Business Unit': 1,
    #     'Claim Number': 2,
    #   },
    #   'Trailer': {
    #     'Record Type': 0,
    #     'Total Batch File LineItem Count': 1,
    #     'Total Batch File Amount Total': 2
    #   }
    # }
    #
    # Instance variable: @data
    # Example:
    # {
    #   'Header': [['value', nil]],
    #   'Detail': [['value', nil, 'value'], ['value', nil, 'value']]
    #   'Trailer': [['value', nil, 'value']]
    # }
    def initialize(delimeter: ',', sections: [])
      # TODO
      # - [ ] validate sections formatting

      @delimeter = delimeter

      @sections = sections

      @column_positions = {}

      # Note: since ruby 1.9, the insertion order is maintained
      # https://www.igvita.com/2009/02/04/ruby-19-internals-ordered-hash
      @data = {}

      sections.each do |section|
        if @data.key?(section[:section_name])
          # TODO raise exception because the same section is defined twice in the sections
        end

        @column_positions[section[:section_name]] = {}
        section[:columns].each_with_index do |column, idx|
          if @column_positions[section[:section_name]].key?(column[:column_name])
            # TODO raise exception because the same column name is defined is defined twice in the sections

            # NOTE! this is a limitation: this library doesn't support 2 columns of the same name, each column
            # name must be unique :(
          end

          @column_positions[section[:section_name]][column[:column_name]] = idx
        end

        @data[section[:section_name]] = []
      end
    end

    # Parameter: section_name
    # Example: 'Trailer'
    #
    # Parameter: rows
    # Example 1: { 'Record Type': 'T', 'Total Batch File LineItem Count': '21' }
    # Example 2: [{ 'Record Type': 'T', 'Total Batch File LineItem Count': '21' }]
    def add_rows_to_section(section_name, rows)
      unless @data.key?(section_name)
        # TODO raise exception because that section name doesn't exist in the sections
      end

      unless rows.kind_of?(Array)
        rows = [rows]
      end

      rows.each do |row|
        new_row = Array.new(@column_positions[section_name].length)

        row.each do |column_name, value|
          new_row[@column_positions[section_name][column_name]] = value
        end

        @data[section_name] << new_row
      end
    end

    def generate_content
      ret_array = []

      @data.each do |_section_name, rows|
        rows.each do |row|
          ret_array << row.join(@delimeter)
        end
      end

      ret_array.join("\n")
    end
  end
end
