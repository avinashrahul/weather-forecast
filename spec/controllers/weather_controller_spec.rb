require "rails_helper"

RSpec.describe WeatherController, type: :controller do
  describe "GET weather data by Zipcode" do
    it "returns error message if invalid params are passed" do
      params = {}
      get :zipcode, params

      expect(@controller.instance_variable_get(:@error_message)).to eq("please enter a valid US 5 digit zipcode")
    end

    it "returns city not found if invalid zipcode is sent" do
      VCR.use_cassette("weather/invalid_zip", record: :once) do
        params = { 'zipcode' => '00000', 'measurement_unit' => 'Fahrenheit'}
        get :zipcode, params: params

        expect(@controller.instance_variable_get(:@current_weather_data)).to eq({"cod"=>"404", "message"=>"city not found"})
      end
    end

    it "returns valid response if valid zipcode is sent" do
      VCR.use_cassette("weather/valid_zip", record: :once) do
        params = { 'zipcode' => '95014', 'measurement_unit' => 'Fahrenheit'}
        get :zipcode, params: params

        expect(@controller.instance_variable_get(:@current_weather_data)['name']).to eq('Cupertino')
      end
    end

    it "returns imperial as unit when Fahrenheit measurement_unit is passed" do
      params = { 'zipcode' => '95014', 'measurement_unit' => 'Fahrenheit'}
      get :zipcode, params: params

      expect(@controller.instance_variable_get(:@measurement_degree)).to eq('°F')
    end
  end
end
