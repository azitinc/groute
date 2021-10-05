# frozen_string_literal: true

RSpec.describe Groute::Meter do
  describe 'new' do
    it 'Meterでインスタンス作成' do
      expect(Groute::Meter.new(3.5)).not_to be nil
    end
  end

  describe 'attr_reader #value' do
    it 'インスタンス生成時に35.0をわたしておくと、それがそのまま手にはいる' do
      expect(Groute::Meter.new(35.0).value).to eq 35.0
    end
  end

  describe '==はvalueとクラスが同じかどうかを比較する' do
    it 'Meterが35.0同士ならばtrueとなる' do
      expect(Groute::Meter.new(35.0) == Groute::Meter.new(35.0)).to be true
    end

    it 'Meterが35.0と20.0ならばfalseとなる' do
      expect(Groute::Meter.new(35.0) == Groute::Meter.new(20.0)).to be false
    end
  end

  describe 'eql?はvalueとクラスが同じかどうかを比較する' do
    it 'Meterが35.0同士ならばtrueとなる' do
      expect(Groute::Meter.new(35.0).eql?(Groute::Meter.new(35.0))).to be true
    end

    it 'Meterが35.0と20.0ならばfalseとなる' do
      expect(Groute::Meter.new(35.0).eql?(Groute::Meter.new(20.0))).to be false
    end
  end
end
