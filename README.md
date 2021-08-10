# Sweater Weather

| Endpoint    | Request Body   |  Returns    | 
| ------------- | ------------- | ------------- |
| `GET /api/v1/forecast?location=denver,co` | n/a | Forecast for a given area, including `current_weather`, 8 hours of `hourly_weather`, 5 days of `daily_weather`| 
| `GET /api/v1/backgrounds?location=denver,co` | n/a | Returns an image search result from Unsplash search of location, current weather conditions, and time of day. Includes link to the image, author, and author profile with appropriate utm parameters in accordance with [Unsplash API Guidelines](https://help.unsplash.com/en/articles/2511245-unsplash-api-guidelines)|  
| `POST /api/v1/users` | `{ "email": "whatever@test.com", "password": "password", "password_confirmation": "password" }` | Creates a new user and returns an API key with successful user creation |
| `POST /api/v1/sessions` | `{ "email": "whatever@test.com", "password": "password" }` | Returns email and API key for existing user if credentials authenticate |
| `POST /api/v1/road_trip` | `{ "origin": "Sample,CO", "destination": "Sample,NY", "api_key": "apikey" }` | Returns roadtrip travel time and weather forecast of destination at ETA. |
