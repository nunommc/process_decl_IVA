# frozen_string_literal: true

require_relative "process_decl_iva/version"
require_relative "process_decl_iva/process_reservations/talkguest"
require_relative "process_decl_iva/process_expenses/e_fatura"
require_relative "process_decl_iva/calculate"

module ProcessDeclIva
  class Error < StandardError; end

  class Runner
    def initialize
      @year = ENV.fetch('Y')
      @quarter = ENV.fetch('T')
    end

    def run
      reporte = ask("Introduza o reporte do trimestre passado [0.00]")
      reporte = 0.0 if reporte.to_f.zero?

      reservations_csv_path = prompt_file("Indique o ficheiro CSV com as reservas do ultimo trimestre", "docs/#{@year}/reservasT#{@quarter}.csv")

      expenses_csv_path = prompt_file("Indique o ficheiro CSV com as despesas do ultimo trimestre", "docs/#{@year}/faturasT#{@quarter}.csv")

      other_commissions = ask("Indique se ocorreu em algumas outras comissoes no trimestre anterior [0.00]")
      other_commissions = 0.0 if other_commissions.to_f.zero?

      reservations_csv  = File.read(reservations_csv_path)
      expenses_csv      = File.read(expenses_csv_path)

      reservations_service = ProcessReservations::Talkguest.new(reservations_csv)

      expenses_service     = ProcessExpenses::EFatura.new(expenses_csv)

      reservations_service.call
      expenses_service.call

      Calculate.new(
        from_last_period:  reporte.to_f,
        total_vat:         expenses_service.total_vat,
        other_commissions: other_commissions.to_f,
        sales_vat:         reservations_service.sales_vat,
        sales_amount:      reservations_service.sales_amount
      ).call
    end

    private

    def ask(string)
      puts string
      STDIN.gets.strip
    end

    def yes?(question)
      answer = ask(question).downcase
      answer == "y" || answer == "yes"
    end

    def prompt_file(question, file_path = nil)
      question_with_default = question.dup

      if file_path
        question_with_default << " [#{file_path}]"
      end
      answer = ask(question_with_default)
      answer = file_path if answer.empty? && file_path

      unless File.exist?(answer)
        puts "O ficheiro nao existe. Verifique se esta na pasta corrente ou indique o endereço completo"

        exit -1
      end

      puts
      answer
    end
  end
end
