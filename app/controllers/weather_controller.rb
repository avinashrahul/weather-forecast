class WeatherController < ApplicationController
  FAHRENHEIT_UNIT = 'Fahrenheit'
  CELSIUS_UNIT = 'Celsius'

  # https://openweathermap.org/current#zip
  # 
  def zipcode
    validate_params
    @measurement_degree = get_degree_of_measurement
    @current_weather_data = get_current_weather
    @weather_forecast_data = get_weather_forecast
  end

  # https://openweathermap.org/current#data
  def get_units_of_measurement
    permitted_params[:measurement_unit] == FAHRENHEIT_UNIT ? 'imperial' : 'metric'
  end

  def get_degree_of_measurement
    permitted_params[:measurement_unit] == FAHRENHEIT_UNIT ? '°F' : '°C'
  end

  def get_current_weather
    weather_url = ENV['OPEN_WEATHER_MAP_URL'] + "/data/2.5/weather?zip=#{params[:zipcode]},us&appid=#{ENV['OPENWEATHERMAP_APPID']}&units=#{get_units_of_measurement}"
    make_http_get_call(weather_url)
  end

  def get_weather_forecast
    forecast_url = ENV['OPEN_WEATHER_MAP_URL'] + "/data/2.5/forecast?zip=#{params[:zipcode]},us&cnt=9&appid=#{ENV['OPENWEATHERMAP_APPID']}&units=#{get_units_of_measurement}"
    make_http_get_call(forecast_url)
  end

  private

  def permitted_params
    params.permit(:zipcode, :measurement_unit)
  end

  def validate_params
    @error_message = 'please enter a valid US 5 digit zipcode' and return if permitted_params[:zipcode].blank?
  end

  def make_http_get_call(url)
    begin
      response =  Net::HTTP.get_response(URI(url))
      if response.present?
        JSON.parse(response.body)
      else
        raise 'Something went wrong. Please try again later'
      end
    rescue StandardError => ex
      Rails.logger.error("Error in making GET request to #{url}, message - #{ex.try(:message)}, backtrace - #{ex.try(:backtrace)}")
      @error_message = ex.message
    end
  end

end
