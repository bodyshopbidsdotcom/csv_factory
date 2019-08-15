require 'spec_helper'

RSpec.describe CsvFactory::Csv do
  it 'shows how it is used' do
    csv = CsvFactory::Csv.new(
      delimeter: '|',
      sections: [
        {
          section_name: 'Header',
          columns: [
            { column_name: 'Record Type' },
            { column_name: 'FROM Job Application Name' },
            { column_name: 'TO Job Application Name' },
          ]
        },
        {
          section_name: 'Detail',
          columns: [
            { column_name: 'Record Type' },
            { column_name: 'Payment Amount' },
            { column_name: 'Payee Name' },
          ]
        },
        {
          section_name: 'Trailer',
          columns: [
            { column_name: 'Record Type' },
            { column_name: 'Payments Count' },
            { column_name: 'Total Amount' },
          ]
        }
      ]
    )

    csv.add_rows_to_section('Header', { 'Record Type' => 'H', 'FROM Job Application Name' => 'PaymentsApp', 'TO Job Application Name' => 'Bank' })
    csv.add_rows_to_section('Detail', [
      { 'Record Type' => 'D', 'Payment Amount' => 100, 'Payee Name' => 'Santiago' },
      { 'Record Type' => 'D', 'Payment Amount' => 100, 'Payee Name' => 'John' },
      { 'Record Type' => 'D', 'Payment Amount' => 100, 'Payee Name' => 'Phil' },
    ])
    csv.add_rows_to_section('Trailer', { 'Record Type' => 'T', 'Payments Count' => 3, 'Total Amount' => 300 } )

    expect(csv.generate_content).to eq([
      'H|PaymentsApp|Bank',
      'D|100|Santiago',
      'D|100|John',
      'D|100|Phil',
      'T|3|300'
    ].join("\n"))
  end

  describe '#initialize' do
    it 'raises an exception if the same section is defined twice' do
      properties = {
        sections: [
          {
            section_name: 'Header',
            columns: [ ]
          },
          {
            section_name: 'Header',
            columns: [ ]
          }
        ]
      }

      expect { CsvFactory::Csv.new(properties) }
        .to raise_error(CsvFactory::Exception, 'The section `Header` is defined twice')
    end

    it 'raises an exception if the same column is defined twice' do
      properties = {
        sections: [
          {
            section_name: 'Header',
            columns: [
              { column_name: 'Column A' },
              { column_name: 'Column A' }
            ]
          }
        ]
      }

      expect { CsvFactory::Csv.new(properties) }
        .to raise_error(CsvFactory::Exception, 'The column `Column A` in the section `Header` is defined twice')
    end
  end

  describe 'add_rows_to_section' do
    it 'raises an exception if the section name was not part of the definition' do
      csv = CsvFactory::Csv.new(
        sections: [
          {
            section_name: 'Header',
            columns: [ ]
          }
        ]
      )

      expect { csv.add_rows_to_section('DoesNotExist', []) }
        .to raise_error(CsvFactory::Exception, 'The section `DoesNotExist` is not defined. Maybe it is a symbol/string incosistency with the definition?')
    end
  end
end
