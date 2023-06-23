require "csv"

module ProcessDeclIva::ProcessReservations
  class Talkguest
    def initialize(csv)
      @csv = CSV.parse(csv, headers: true)
    end

    attr_reader :csv
    attr_accessor :sales_amount, :sales_vat

    def call
      @sales_amount = sum_by("Base Incidência")
      @sales_vat = sum_by("Total Do IVA")
    end

    private

    def sum_by(column_name)
      rows.map { |row| row[column_name].to_f }.sum
    end

    def rows
      csv.reject { |r| ![0, "0", "FALSE"].include?(r["Anulado"]) }
    end
  end
end
