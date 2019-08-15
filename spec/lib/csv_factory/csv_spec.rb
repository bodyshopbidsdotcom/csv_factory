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
            { column_name: 'Environment Type' },
            { column_name: 'FROM Job Application Name' },
            { column_name: 'TO Job Application Name' },
            { column_name: 'Batch Job Name' },
            { column_name: 'Batch Job Server Name' },
            { column_name: 'Batch Job CorrelationId' },
            { column_name: 'Batch File Name' },
            { column_name: 'Batch File Creation DateTime' },
            { column_name: 'Batch File CorrelationId' },
            { column_name: 'Batch File Sequence Number' }
          ]
        },
        {
          section_name: 'Detail',
          columns: [
            { column_name: 'Record Type' },
            { column_name: 'Business Unit' },
            { column_name: 'Claim Number' },
          ]
        },
        {
          section_name: 'Trailer',
          columns: [
            { column_name: 'Record Type' },
            { column_name: 'Total Batch File LineItem Count' },
            { column_name: 'Total Batch File Amount Total' },
          ]
        }
      ]
    )

    csv.add_rows_to_section('Header', { 'Record Type' => 'H', 'Environment Type' => 'PRD', 'Batch File Name' => 'batch22.txt' })
    expect(csv.generate_content).to eq('H|PRD||||||batch22.txt|||')

    csv.add_rows_to_section('Detail', [ { 'Record Type' => 'D', 'Claim Number' => '22' } ])
    expect(csv.generate_content).to eq([
      'H|PRD||||||batch22.txt|||',
      'D||22'
    ].join("\n"))

    csv.add_rows_to_section('Trailer', [ { 'Total Batch File Amount Total' => 'nice', 'Total Batch File LineItem Count' => 69 } ])
    expect(csv.generate_content).to eq([
      'H|PRD||||||batch22.txt|||',
      'D||22',
      '|69|nice'
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
