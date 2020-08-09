RSpec.describe Groute::LatLng do
  describe 'new' do
    it "latitutude, longitudeでインスタンス作成" do
      expect(Groute::LatLng.new(35.0, 135.0)).not_to be nil
    end
  end

  describe 'attr_reader #latitude' do
    it 'インスタンス生成時に35.0をわたしておくと、それがそのまま手にはいる' do
      latitude = 35.0
      expect(Groute::LatLng.new(latitude, 135.0).latitude).to eq latitude
    end
  end

  describe 'attr_reader #longitude' do
    it 'インスタンス生成時に135.0をわたしておくと、それがそのまま手にはいる' do
      longitude = 135.0
      expect(Groute::LatLng.new(35.0, longitude).longitude).to eq longitude
    end
  end

  describe '==は同じクラスでlatitude, longitudeが同じかどうかを確認する' do
    it 'latitude, longitudeが共に同じ35.0, 135.0ならばtrueになる' do
      expect(Groute::LatLng.new(35.0, 135.0) == Groute::LatLng.new(35.0, 135.0)).to be true
    end
    
    it 'latitude, longitudeが(35.0, 135.0)と(35.0, 500.0)ならばfalseになる' do
      expect(Groute::LatLng.new(35.0, 135.0) == Groute::LatLng.new(35.0, 500.0)).to be false
    end

    it 'latitude, longitudeが(35.0, 135.0)と(50.0, 135.0)ならばfalseになる' do
      expect(Groute::LatLng.new(35.0, 135.0) == Groute::LatLng.new(50.0, 135.0)).to be false
    end

    it 'latitude, longitudeが(35.0, 135.0)と(50.0, 500.0)ならばfalseになる' do
      expect(Groute::LatLng.new(35.0, 135.0) == Groute::LatLng.new(50.0, 500.0)).to be false
    end
  end
end
