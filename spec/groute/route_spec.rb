RSpec.describe Groute::Route do
  describe 'new' do
    it "minutes, distanceでインスタンス生成" do
      expect(Groute::Route.new(35.0, Groute::Distance.new(3))).not_to be nil
    end
  end

  describe 'reader #minutes' do
    it "生成時に、5.0をわたしておくと、それがそのまま手にはいる" do
      expect(Groute::Route.new(5.0, Groute::Distance.new(3)).minutes).to eq 5.0
    end
  end

  describe 'reader #distance' do
    it "生成時に、わたしたdistanceがそのまま手にはいる" do
      expect(Groute::Route.new(5.0, Groute::Distance.new(3)).distance).to eq Groute::Distance.new(3)
    end
  end

  describe '==はクラス、時間と距離の一致を確認する' do
    it "時間と距離が一緒ならばtrue" do
      expect(
        Groute::Route.new(5.0, Groute::Distance.new(3)) == Groute::Route.new(5.0, Groute::Distance.new(3))
      ).to be true
    end

    it "時間が異るとfalse" do
      expect(
        Groute::Route.new(5.0, Groute::Distance.new(3)) == Groute::Route.new(2.0, Groute::Distance.new(3))
      ).to be false
    end

    it "距離が異るとfalse" do
      expect(
        Groute::Route.new(5.0, Groute::Distance.new(3)) == Groute::Route.new(5.0, Groute::Distance.new(5))
      ).to be false
    end

    it "時間と距離が共に異るとfalse" do
      expect(
        Groute::Route.new(5.0, Groute::Distance.new(3)) == Groute::Route.new(3.0, Groute::Distance.new(5))
      ).to be false
    end

    it "同じプロパティをもっていてもクラスが違うとfalse" do
      struc = Struct.new("Distance", :minutes, :distance)
      expect(
        Groute::Route.new(5.0, Groute::Distance.new(3)) == struc.new(3.0, Groute::Distance.new(5))
      ).to be false
    end
  end

  describe 'eql?はクラス、時間と距離の一致を確認する' do
    it "時間と距離が一緒ならばtrue" do
      expect(
        Groute::Route.new(5.0, Groute::Distance.new(3)).eql? Groute::Route.new(5.0, Groute::Distance.new(3))
      ).to be true
    end

    it "時間が異るとfalse" do
      expect(
        Groute::Route.new(5.0, Groute::Distance.new(3)).eql? Groute::Route.new(2.0, Groute::Distance.new(3))
      ).to be false
    end

    it "距離が異るとfalse" do
      expect(
        Groute::Route.new(5.0, Groute::Distance.new(3)).eql? Groute::Route.new(5.0, Groute::Distance.new(5))
      ).to be false
    end

    it "時間と距離が共に異るとfalse" do
      expect(
        Groute::Route.new(5.0, Groute::Distance.new(3)).eql? Groute::Route.new(3.0, Groute::Distance.new(5))
      ).to be false
    end

    it "同じプロパティをもっていてもクラスが違うとfalse" do
      struc = Struct.new("Distance", :minutes, :distance)
      expect(
        Groute::Route.new(5.0, Groute::Distance.new(3)).eql? struc.new(3.0, Groute::Distance.new(5))
      ).to be false
    end
  end
end
