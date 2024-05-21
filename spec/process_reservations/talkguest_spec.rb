# frozen_string_literal: true

require "spec_helper"
require "process_decl_iva/process_reservations/talkguest"

RSpec.describe ProcessDeclIva::ProcessReservations::Talkguest do
  subject { described_class.new(file) }

  context "with a correct CSV file" do
    let(:file) do
      <<~ROWS
        Documento,Data,Cliente,Alojamento,Contribuinte,Total Base Incidência,Total Do IVA,Total Documento,Base Incidência,Taxa IVA %,Valor IVA,Anulado
        FR B/4,25-2-2023,Kristiana Vinkalne,Vaumar,999999990,742.04,44.52,786.56,742.04,6,44.52,0
        FR B/5,31-3-2023,Basia Kubinowska,Turimar,999999990,250.94,15.06,266,250.94,6,15.06,0
        FR B/6,31-3-2023,Georgelin Christian,Vaumar,999999990,292.83,17.57,310.4,292.83,6,17.57,0
      ROWS
    end

    it "calculates total sales amount" do
      subject.call

      expect(subject.sales_amount).to eq(1285.81)
    end

    it "calculates total VAT amount" do
      subject.call

      expect(subject.sales_vat).to eq(77.15)
    end
  end

  context "when file is poorly converted (extra decimal point)" do
    let(:file) do
      <<~ROWS
        Documento,Data,Cliente,Alojamento,Contribuinte,Total Base Incidência,Total Do IVA,Total Documento,Base Incidência,Taxa IVA %,Valor IVA,Anulado
        FR B/4,25-2-2023,Kristiana Vinkalne,Vaumar,999999990,742.03999999999996,44.520000000000003,786.55999999999995,742.03999999999996,6,44.520000000000003,0
        FR B/5,31-3-2023,Basia Kubinowska,Turimar,999999990,250.94,15.06,266,250.94,6,15.06,0
        FR B/6,31-3-2023,Georgelin Christian,Vaumar,999999990,292.82999999999998,17.57,310.39999999999998,292.82999999999998,6,17.57,0
      ROWS
    end

    it "calculates total sales amount" do
      subject.call

      expect(subject.sales_amount).to eq(1285.81)
    end

    it "calculates total VAT amount" do
      subject.call

      expect(subject.sales_vat).to eq(77.15)
    end
  end

  context "when includes voided invoices" do
    let(:file) do
      <<~ROWS
        Documento,Data,Cliente,Alojamento,Contribuinte,Total Base Incidência,Total Do IVA,Total Documento,Base Incidência,Taxa IVA %,Valor IVA,Anulado
        FR B/4,25-2-2023,Kristiana Vinkalne,Vaumar,999999990,742.03999999999996,44.520000000000003,786.55999999999995,742.03999999999996,6,44.520000000000003,TRUE
        FR B/5,31-3-2023,Basia Kubinowska,Turimar,999999990,250.94,15.06,266,250.94,6,15.06,0
        FR B/6,31-3-2023,Georgelin Christian,Vaumar,999999990,292.82999999999998,17.57,310.39999999999998,292.82999999999998,6,17.57,FALSE
      ROWS
    end

    it "calculates total sales amount" do
      pending "This test requires fixing"
      subject.call

      expect(subject.sales_amount).to eq(543.77)
    end

    it "calculates total VAT amount" do
      pending "This test requires fixing"
      subject.call

      expect(subject.sales_vat).to eq(32.63)
    end
  end
end
