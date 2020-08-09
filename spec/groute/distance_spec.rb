# frozen_string_literal: true

RSpec.describe Groute::Distance do
  describe 'new' do
    it 'distanceでインスタンス作成' do
      expect(Groute::Distance.new(3.5)).not_to be nil
    end
  end

  describe 'attr_reader #distance' do
    it 'インスタンス生成時に35.0をわたしておくと、それがそのまま手にはいる' do
      expect(Groute::Distance.new(35.0).distance).to eq 35.0
    end
  end

  describe '==はdistanceとクラスが同じかどうかを比較する' do
    it 'distanceが35.0同士ならばtrueとなる' do
      expect(Groute::Distance.new(35.0) == Groute::Distance.new(35.0)).to be true
    end

    it 'distanceが35.0と20.0ならばfalseとなる' do
      expect(Groute::Distance.new(35.0) == Groute::Distance.new(20.0)).to be false
    end
  end

  describe 'eql?はdistanceとクラスが同じかどうかを比較する' do
    it 'distanceが35.0同士ならばtrueとなる' do
      expect(Groute::Distance.new(35.0).eql?(Groute::Distance.new(35.0))).to be true
    end

    it 'distanceが35.0と20.0ならばfalseとなる' do
      expect(Groute::Distance.new(35.0).eql?(Groute::Distance.new(20.0))).to be false
    end
  end
end
