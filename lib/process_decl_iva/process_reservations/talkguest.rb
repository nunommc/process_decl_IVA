require 'csv'

module ProcessDeclIva::ProcessReservations
  class Talkguest
    def initialize(csv)
      @csv = CSV.parse(csv, headers: true)
    end

    attr_reader :csv
    attr_accessor :sales_amount, :sales_vat, :commissions

    def call
      @sales_amount = sum_by("Base Incidência")
      @sales_vat = sum_by("Total Do IVA")
      @commissions = (@sales_amount + @sales_vat) * 0.15
    end

    private

    def sum_by(column_name)
      csv.map { |row| row[column_name].to_f }.sum
    end
  end
end
