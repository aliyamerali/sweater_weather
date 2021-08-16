# Sweater Weather
<a href="https://img.shields.io/badge/coverage-99.87%25-green">
        <img src="https://img.shields.io/badge/coverage-99.87%25-green"
            alt="coverage"></a>


## Project Description 
Sweater Weather is a back-end Rails application that exposes a set of endpoints to support an app used for planning roadtrips in a service-oriented architecture. Endpoints expose weather forecast data, roadtrip routes and future forecasts at destinations, and images for location and time specific weather forecasts. It also supports user registration, login, and the assignment and validation of API keys.

All API responses follow the [JSON:API](https://jsonapi.org/) format conventions.

Timeframe: 5 days   
Contributor: 
- Aliya Merali  
   [Github](https://github.com/aliyamerali) | [LinkedIn](https://www.linkedin.com/in/aliyamerali/)

## Available Endpoints

| Endpoint    | Request Body   |  Returns    | 
| ------------- | ------------- | ------------- |
| `GET /api/v1/forecast?location=denver,co` + optional param for units (imperial or metric)| n/a | Forecast for a given area, including `current_weather`, 8 hours of `hourly_weather`, 5 days of `daily_weather`. Units default to imperial unless otherwise specified. | 
| `GET /api/v1/backgrounds?location=denver,co` | n/a | Returns an image search result from Unsplash search of location, current weather conditions, and time of day. Includes link to the image, author, and author profile with appropriate utm parameters in accordance with [Unsplash API Guidelines](https://help.unsplash.com/en/articles/2511245-unsplash-api-guidelines). |  
| `POST /api/v1/users` | `{ "email": "whatever@test.com", "password": "password", "password_confirmation": "password" }` | Creates a new user and returns an API key with successful user creation.  |
| `POST /api/v1/sessions` | `{ "email": "whatever@test.com", "password": "password" }` | Returns email and API key for existing user if credentials authenticate.  |
| `POST /api/v1/road_trip` + optional param for units (imperial or metric)| `{ "origin": "Sample,CO", "destination": "Sample,NY", "api_key": "apikey" }` | Returns roadtrip travel time and weather forecast of destination at ETA. Units default to imperial unless otherwise specified. |

## Setup
To setup these endpoints locally: 
1. clone this repo to your local machine
2. run `bundle install`
3. install [Figaro](https://github.com/laserlemon/figaro) by running `bundle exec figaro install`
4. add API keys to the `config/.application.yml` for the [Mapquest](https://developer.mapquest.com/documentation/), [OpenWeather](https://openweathermap.org/api/one-call-api), and [Unsplash](https://unsplash.com/documentation) APIs: 
   ```
   MAPQUEST_API_KEY: <your API key>
   WEATHER_API_KEY: <your API key>
   UNSPLASH_API_KEY: <your API key>
   ```
5. run `rails db:{create,migrate}` to setup the database
6. run `rails s` and navigate to http://localhost:3000 with the desired endpoint for `get` requests, and/or use a tool like [Postman](https://www.postman.com) for `post` requests. 
