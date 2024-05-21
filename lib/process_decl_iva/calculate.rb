module ProcessDeclIva
  class Calculate
    VAT = (0.23).freeze

    def initialize(
      from_last_period:,
      total_vat:,
      commissions:,
      sales_vat:,
      sales_amount:
    )

      @from_last_period = from_last_period
      @total_expenses_vat = total_vat
      @commissions = commissions
      @sales_vat = sales_vat
      @sales_amount = sales_amount
    end

    # Total serviços prestados
    def field_1
      @sales_amount
    end

    # IVA liquidado serviços prestados
    def field_2
      @sales_vat
    end

    # Serviços efetuados por sujeitos passivos de outros Estados membros cujo imposto foi liquidado pelo declarante
    def field_16
      @commissions
    end

    # [16] * IVA
    def field_17
      field_16 * VAT
    end

    # Imposto Dedutivel: Outros bens e serviços
    def field_24
      @total_expenses_vat + field_17
    end

    # Excesso a reportar do período anterior
    def field_61
      @from_last_period - field_2 - field_17
    end

    # Operações localizadas em Portugal em que, na qualidade de adquirente, liquidou o IVA devido
    # Países comunitários
    def field_97
      field_16
    end

    def call
      {
        '1' => field_1,
        '2' => field_2,
        '16' => field_16,
        '17' => field_17,
        '24' => field_24,
        '61' => field_61,
        '97' => field_97
      }.each do |field_nr, value|
        puts [ "| ", field_nr.ljust(4), "| ", value.round(2).to_s.ljust(10), "|"].join
      end

      # puts "1: #{field_1.round(2)}"
      # puts "2: #{field_2.round(2)}"
      # puts "16: #{field_16.round(2)}"
      # puts "17: #{field_17.round(2)}"
      # puts "24: #{field_24.round(2)}"
      # puts "61: #{field_61.round(2)}"
      # puts "97: #{field_97.round(2)}"
    end
  end
end
