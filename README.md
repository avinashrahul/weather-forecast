# weather-forecast

### Context
Displays the current weather and extended forecast based on the zipcode. User can choose to display the weather data either in Celsius or Fahrenheit. 

This leverages actual weather data from https://openweathermap.org/. To use this functionality sign up from https://home.openweathermap.org/users/sign_up to get a new API key. This needs to be set in 
`ENV[OPENWEATHERMAP_APPID]`.


### Validations
1. This validates the Zip code.
2. This validates the Zip code presence.

### Functionality
1. Fetches current weather and forecasted weather based on Zipcode.
2. User can select his measurement either Celsius/Fahrenheit based on their convenience.
3. Weather and Forecast data is stored in cache for 30 minutes based on `Zipcode and measurement` lookup which can be configurable.
4. Specs are written by leveraging VCR to test the actual API functionality.
5. This uses `.env` to handle environment variables.

![Screen Shot 2022-03-06 at 5 30 40 PM](https://user-images.githubusercontent.com/8624234/156944959-3da9cb6c-ff71-4fcc-8be5-b52fa1ba0652.png)



### Steps to Run
1. Clone the application
2. RUN - bundle install
3. RUN - rails server
4. Make sure you have below environment variables in `.env` file.

```RAILS_ENV=development
OPENWEATHERMAP_APPID=XXX
RAILS_MASTER_KEY=XXX
OPEN_WEATHER_MAP_URL=http://api.openweathermap.org
```

We can enhance the current functionality by providing `City/State/Zip` as an option to fetch the Weather report.

**Note**: If you face issues running the application or have any questions. Please reach out to - `rahulgudimetla99@gmail.com`

Thanks!
