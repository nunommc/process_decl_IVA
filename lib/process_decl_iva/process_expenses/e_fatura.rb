require "csv"

# CSV::Converters[:mytime] = lambda{|s|
#   begin
#     Time.parse(s)
#   rescue ArgumentError
#     s
#   end
# }

# class NumericWithCurrencyConverter < CSV::Converter
#   def initialize(field_info)
#     super
#     @currency_regex = /[$€]/
#   end

#   def call(value, field_info)
#     return value unless value.is_a?(String)
#     value.gsub(@currency_regex, '').to_f
#   end
# end

CSV::Converters[:numeric_with_currency] = lambda do |f|
  f.is_a?(String) ? f.gsub(/[$€]/, "").tr(",", ".").strip : f
rescue # encoding conversion or date parse errors
  f
end

module ProcessDeclIva::ProcessExpenses
  class EFatura
    def initialize(csv)
      @csv = CSV.parse(
        csv,
        headers: true,
        converters: %i[numeric_with_currency numeric],
        liberal_parsing: true,
        col_sep: ";"
      )
    end

    attr_reader :csv
    attr_accessor :total, :total_vat

    def call
      transform_credit_notes

      @total = sum_by("Total")
      @total_vat = sum_by("IVA")
    end

    private

    def sum_by(column_name)
      csv.map { |row| row[column_name].to_f }.sum
    end

    def transform_credit_notes
      csv.select { |row| row["Tipo"] =~ /crédito/i }.each do |row|
        row["Total"] *= -1
        row["IVA"] *= -1
        row["Base Tributável"] *= -1
      end
    end
  end
end
