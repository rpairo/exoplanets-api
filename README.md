# Exoplanets API

The Exoplanets API is a Swift-based web service that provides information about exoplanets. It fetches data from a [ExoplanetAnalyzer](https://github.com/rpairo/exoplanets), processes it, and exposes endpoints for clients to retrieve information such as orphan exoplanets, the hottest star exoplanet, and a discovery timeline of exoplanets grouped by size.

It also provides a website to improve your experience navigating into it.

## Endpoints
When the server is running, you can access to two different services at same time: Website or API.

- **API**: By using the API path, you will be able to retrieve in JSON format the information from ExoplanetAnalyzer.
    - localhost:8080/api/orphans
    - localhost:8080/api/hottest
    - localhost:8080/api/timeline

- **Website**: By using the API path, you will be able to retrieve in JSON format the information from ExoplanetAnalyzer.
    - localhost:8080/website/
    - localhost:8080/website/orphans
    - localhost:8080/website/hottest
    - localhost:8080/website/timeline

## Website
### /website/
![Orphans](https://github.com/user-attachments/assets/68e81179-8401-4553-8c59-3e358f9fec6d)

### /website/orphans
![Orphans](https://github.com/user-attachments/assets/defc00f0-b745-4cc4-a748-6099f15d0c84)

### /website/hottest
![Orphans](https://github.com/user-attachments/assets/ca940fc4-d4b4-45fb-a0a4-498290d8f841)

### /website/timeline
![Orphans](https://github.com/user-attachments/assets/38a6008d-f561-43e0-9346-30546a6cbd3e)


## API (JSON)
### /api/orphans
![Orphans](https://github.com/user-attachments/assets/8b2bc416-af59-4741-9693-26a87121147c)


### /api/hottest
![Hottest](https://github.com/user-attachments/assets/b8b66bd0-6af6-43a7-b040-a9605a764291)

### /api/timeline
![Timeline](https://github.com/user-attachments/assets/e36eeb0f-c700-4173-ac6b-1d911f4923a6)


## Testing
#### Running the tests
The tests files are located in the `Tests/` directory in the project root. They are mirroning the `Sources/` structure to make easier the management.
In order to make easier to run the testing, I have created the file [setup-tests-manual.sh](setup-tests-manual.sh), wich will set up the env variables and run the tests by terminal.
Another option is to open the project by Xcode, and run the test by pressing `"CMD + U"`

![Manual testing](https://github.com/user-attachments/assets/491e9f3f-659c-4a21-8301-5959a4e18131)


### Project Structure
The project follows a modular architecture with the following components:
- Domain: Contains core business logic and models.
- Data: Handles data fetching and processing.
- Infrastructure: Manages configurations and external services integration.
- Presentation: Prepares and formats data for API responses.
- Composition: Assembles dependencies and builds the application.
- API: Exposes the endpoints for client interactions.
