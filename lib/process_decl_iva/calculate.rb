module ProcessDeclIva
  class Calculate
    VAT = 0.23

    def initialize(
      from_last_period:,
      total_vat:,
      other_commissions:,
      sales_vat:,
      sales_amount:
    )

      @from_last_period = from_last_period
      @total_expenses_vat = total_vat
      @other_commissions = other_commissions
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
    # Comissoes
    def field_16
      (field_1 + field_2) * 0.15 + @other_commissions
    end

    # [16] * IVA
    def field_17
      field_16 * VAT
    end

    # Imposto Dedutivel: Outros bens e serviços
    def field_24
      @total_expenses_vat + field_17
    end

    # Excesso a reportar para o período anterior
    def field_61
      @from_last_period
    end

    def field_96
      field_61 + field_24 - field_2 - field_17
    end

    # Operações localizadas em Portugal em que, na qualidade de adquirente, liquidou o IVA devido
    # Países comunitários
    def field_97
      field_16
    end

    def call
      {
        "1" => field_1,
        "2" => field_2,
        "16" => field_16,
        "17" => field_17,
        "24" => field_24,
        "61" => field_61,
        "96" => field_96,
        "97" => field_97
      }.each do |field_nr, value|
        puts ["| ", field_nr.ljust(4), "| ", value.round(2).to_s.ljust(10), "|"].join
      end
    end
  end
end
