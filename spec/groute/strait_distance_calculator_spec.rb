RSpec.describe Groute::StraitDistanceCalculator do
  describe 'call' do
    it "LatLngを二つ取る" do
      origin = Groute::LatLng.new(35.0, 135.0)
      destination = Groute::LatLng.new(30.0, 135.0)
      expect(Groute::StraitDistanceCalculator.call(origin, destination)).not_to be nil
    end

    it "Groute::Distanceを返す" do
      origin = Groute::LatLng.new(35.0, 135.0)
      destination = Groute::LatLng.new(30.0, 135.0)
      expect(Groute::StraitDistanceCalculator.call(origin, destination)).to be_an_instance_of(Groute::Distance)
    end
  end
end
