# frozen_string_literal: true

require "spec_helper"
require "process_decl_iva/process_expenses/e_fatura"

RSpec.describe ProcessDeclIva::ProcessExpenses::EFatura do
  subject { described_class.new(file) }

  context "with a correct CSV file" do
    let(:file) do
      <<~CSV
        "Setor";"Emitente";"Nº Fatura / ATCUD";"Tipo";"Data Emissão";"Total";"IVA";"Base Tributável";"Situação";"Comunicação  Emitente";"Comunicação  Adquirente"
        "Outros";"502236469 - Nepeli Materiais Construcao Lda";"FR 2023ACM1/163 / JF2JS32H-163";"Fatura-recibo";"2023-02-03";"527,39 €";"98,62 €";"428,77 €";"Registado";"X";""
        "Outros";"503373907 - Loja Materiais de Construçao Lda";"FR 22-V002.01/1260 / JFH2GTHJ-1260";"Fatura-recibo";"2023-02-02";"313,65 €";"58,65 €";"255,00 €";"Registado";"X";""
        "Outros";"502236469 - Nepeli Lda";"NC 72/19847 / JFBD7-19847";"Nota de crédito";"2023-03-10";"275,24 €";"51,47 €";"223,77 €";"Registado";"X";""
        "Outros";"502236469 - Nepeli Lda";"FT 1/98305 / JF2P3-98305";"Fatura";"2023-03-10";"275,24 €";"51,47 €";"223,77 €";"Registado";"X";""
        "Outros";"501281231 - Leroy S A";"FR FR.PT/28481 / JF9YMVGB-28481";"Fatura-recibo";"2023-03-10";"145,63 €";"27,23 €";"118,40 €";"Registado";"X";""
        "Outros";"504615947 - Meo - Serviços de Comunicações e Multimédia S.A.";"FT A/788663225 / JFF66VKK-788663225";"Fatura";"2023-03-23";"85,02 €";"15,90 €";"69,12 €";"Registado";"X";""
      CSV
    end

    it "calculates total sales amount" do
      subject.call

      expect(subject.total).to eq(1071.69)
    end

    it "calculates total VAT amount" do
      subject.call

      expect(subject.total_vat).to eq(200.4)
    end

    it "removes currency symbols" do
      subject.call

      aggregate_failures do
        expect(subject.csv.to_s).not_to include("€")

        totals = subject.csv.map { |row| row["Total"] }
        expect(totals).to all be_a(Float)
      end
    end

    it "multiplies amount by -1 for credit notes" do
      subject.call

      credit_note = subject.csv[2]
      expect(credit_note["Total"]).to be_negative
      expect(credit_note["IVA"]).to be_negative
      expect(credit_note["Base Tributável"]).to be_negative

      other_rows = subject.csv
      other_rows.each_with_index do |row, index|
        next if index == 2

        aggregate_failures("row #{index}") do
          expect(row["Total"]).to be_positive
          expect(row["IVA"]).to be_positive
          expect(row["Base Tributável"]).to be_positive
        end
      end
    end
  end
end
