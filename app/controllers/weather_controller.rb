class WeatherController < ApplicationController
  FAHRENHEIT_UNIT = 'Fahrenheit'
  CELSIUS_UNIT = 'Celsius'
  CACHE_EXPIRATION_TIME = 30.minutes

  def new; end

  def zipcode
    return @error_message unless validate_params
    Rails.logger.info("Request received for Zipcode #{permitted_params[:zipcode]}")
    @is_cached = false
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

  # https://openweathermap.org/current#zip
  def get_current_weather
    cache_key = "get_current_weather_#{permitted_params[:zipcode]}_#{get_units_of_measurement}"
    weather_url = ENV['OPEN_WEATHER_MAP_URL'] + "/data/2.5/weather?zip=#{permitted_params[:zipcode]},us&appid=#{ENV['OPENWEATHERMAP_APPID']}&units=#{get_units_of_measurement}"
    weather_data = make_http_get_call(weather_url)
    write_to_cache(cache_key, weather_data)
    weather_data
  end

  def get_weather_forecast
    cache_key = "get_weather_forecast_#{permitted_params[:zipcode]}_#{get_units_of_measurement}"
    # If Forecast timestamp cards count is changed we have to clear the cache to reflect updated data. We can make this as ENV variable.
    forecast_url = ENV['OPEN_WEATHER_MAP_URL'] + "/data/2.5/forecast?zip=#{permitted_params[:zipcode]},us&cnt=6&appid=#{ENV['OPENWEATHERMAP_APPID']}&units=#{get_units_of_measurement}"
    forecast_data = make_http_get_call(forecast_url)
    write_to_cache(cache_key, forecast_data)
    forecast_data
  end

  private

  def permitted_params
    params.permit(:zipcode, :measurement_unit)
  end

  def write_to_cache(cache_key, data)
    if Rails.cache.exist?(cache_key)
      @is_cached = true
      return
    end
    Rails.cache.write(cache_key, data, expires_in: CACHE_EXPIRATION_TIME) unless %w(401).include?(data['cod']) || @error_message.present? # Add more error codes if applicable
  end

  def validate_params
    if permitted_params[:zipcode].blank?
      @error_message = 'please enter a valid US 5 digit zipcode'
      return false
    end
    true
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
