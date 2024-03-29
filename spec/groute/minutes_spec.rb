# frozen_string_literal: true

RSpec.describe Groute::Minutes do
  describe 'new' do
    it 'Minutesでインスタンス作成' do
      expect(Groute::Minutes.new(3.5)).not_to be nil
    end
  end

  describe 'attr_reader #value' do
    it 'インスタンス生成時に35.0をわたしておくと、それがそのまま手にはいる' do
      expect(Groute::Minutes.new(35.0).value).to eq 35.0
    end
  end

  describe '==はvalueとクラスが同じかどうかを比較する' do
    it 'Minutesが35.0同士ならばtrueとなる' do
      expect(Groute::Minutes.new(35.0) == Groute::Minutes.new(35.0)).to be true
    end

    it 'Minutesが35.0と20.0ならばfalseとなる' do
      expect(Groute::Minutes.new(35.0) == Groute::Minutes.new(20.0)).to be false
    end
  end

  describe 'eql?はvalueとクラスが同じかどうかを比較する' do
    it 'Minutesが35.0同士ならばtrueとなる' do
      expect(Groute::Minutes.new(35.0).eql?(Groute::Minutes.new(35.0))).to be true
    end

    it 'Minutesが35.0と20.0ならばfalseとなる' do
      expect(Groute::Minutes.new(35.0).eql?(Groute::Minutes.new(20.0))).to be false
    end
  end
end
