# Sweater Weather

| Endpoint        | Returns           | 
| ------------- | ------------- | 
| `GET /api/v1/forecast?location=denver,co` | Forecast for a given area, including `current_weather`, 8 hours of `hourly_weather`, 5 days of `daily_weather`| 
| `GET /api/v1/backgrounds?location=denver,co` | Returns an image search result from Unsplash search of location, current weather conditions, and time of day. Includes link to the image, author, and author profile with appropriate utm parameters in accordance with [Unsplash API Guidelines](https://help.unsplash.com/en/articles/2511245-unsplash-api-guidelines)|  
