# frozen_string_literal: true

RSpec.describe Groute::Route do
  describe 'new' do
    it 'duration, distanceでインスタンス生成' do
      expect(Groute::Route.new(
               duration: Groute::Minutes.new(35.0),
               distance: Groute::Meter.new(3)
             )).not_to be nil
    end
  end

  describe 'reader #minutes' do
    it '生成時に、5.0をわたしておくと、それがそのまま手にはいる' do
      expect(Groute::Route.new(
        duration: Groute::Minutes.new(5.0),
        distance: Groute::Meter.new(3)
      ).duration).to eq Groute::Minutes.new(5.0)
    end
  end

  describe 'reader #distance' do
    it '生成時に、わたしたdistanceがそのまま手にはいる' do
      expect(Groute::Route.new(
        duration: Groute::Minutes.new(5.0),
        distance: Groute::Meter.new(3)
      ).distance).to eq Groute::Meter.new(3)
    end
  end

  describe '==はクラス、時間と距離の一致を確認する' do
    it '時間と距離が一緒ならばtrue' do
      expect(
        Groute::Route.new(duration: Groute::Minutes.new(5.0), distance: Groute::Meter.new(3)) == \
          Groute::Route.new(duration: Groute::Minutes.new(5.0), distance: Groute::Meter.new(3))
      ).to be true
    end

    it '時間が異るとfalse' do
      expect(
        Groute::Route.new(duration: Groute::Minutes.new(5.0), distance: Groute::Meter.new(3)) == \
          Groute::Route.new(duration: Groute::Minutes.new(3.0), distance: Groute::Meter.new(3))
      ).to be false
    end

    it '距離が異るとfalse' do
      expect(
        Groute::Route.new(duration: Groute::Minutes.new(5.0), distance: Groute::Meter.new(3)) == \
          Groute::Route.new(duration: Groute::Minutes.new(5.0), distance: Groute::Meter.new(5))
      ).to be false
    end

    it '時間と距離が共に異るとfalse' do
      expect(
        Groute::Route.new(duration: Groute::Minutes.new(5.0), distance: Groute::Meter.new(3)) == \
          Groute::Route.new(duration: Groute::Minutes.new(3.0), distance: Groute::Meter.new(5))
      ).to be false
    end
  end

  describe 'eql?は==のエイリアス' do
    it do
      inst = Groute::Route.new(duration: Groute::Minutes.new(5.0), distance: Groute::Meter.new(3))
      expect(inst.method(:==)).to eq inst.method(:eql?)
    end
  end
end
