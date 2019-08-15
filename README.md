# CsvFactory

Tool that lets you easily generate csv content given a predefined schema

## Installation

Add these lines to your application's Gemfile:

```ruby
gem 'csv_factory'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install csv_factory

## Usage
Let's say you need to create a csv file that is pipe (`|`) delimeted and has the following structure:
- The first row is a Header row with the following columns, in order:
  - `Record Type`
  - `FROM Job Application Name`
  - `TO Job Application Name`
- Then there's a `Detail` section that contains multiple rows, where each rows has the following columns in order:
  - `Record Type`
  - `Payment Amount`
  - `Payee Name`
- Lastly, there's a `Trailer` section that is a single row. This row has the following columns in order:
  - `Record Type`
  - `Payments Count`
  - `Total Amount`

An example of a file like this would look like this:
```
H|PaymentsApp|Bank
D|100|Santiago
D|100|John
D|100|Phil
T|3|300
```

To generate that content using this gem, do the following:
```ruby
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
```

And that's it. `csv.generate_content` will return the the csv content exactly as shown above as a string.
