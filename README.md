# Exoplanets API

[The Exoplanets API](https://github.com/rpairo/exoplanets-api) is a Swift-based web service that provides information about exoplanets. It fetches data from a [ExoplanetAnalyzer](https://github.com/rpairo/exoplanets) importing it as Swift Package Manager as a [library](https://github.com/rpairo/exoplanets/releases/tag/v1.0.12). Then processes the received data, and exposes endpoints for clients to retrieve information such as orphan exoplanets, the hottest star exoplanet, and a discovery timeline of exoplanets grouped by size.

It also provides a website to improve your experience navigating into it.
It also uses a Google Custom Search API to fetch the exoplanet image. It would works dinamically. Before to use the google search api I have tried the NASA images one and the Wikimedia. But there were not pictures about these exoplanets. I thought maybe google could has, yes!

**NASA**:
- https://api.nasa.gov
- https://images.nasa.gov/

**Google**
- https://developers.google.com/custom-search


The json models will be a mirror of exoplanet ones, but I have added also the URL of its picture, just to collaborate a bit to improve it.

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

## Requeriments
To properly run the project, it will be expecting 5 env vars. They will be fetched by AWS Secrets Manager if you use the AWS CLI with the "-aws-".sh to run Docker and Kubernetes.
- **BASE_URL**
- **PATH_SEGMENT**
- **ENDPOINT_EXOPLANETS**
- **GOOGLE_API_KEY**
- **GOOGLE_SEARCH_ENGINE_ID**

## Docker
you can run it in docker by the scripts that I have prepared for it.
- **/docker/setup-docker.sh**: easiest way, just inject the env vars and run run docker.
- **/docker/setup-docker-aws-secrets-sh**: if you want to use the AWS secrets Manager, **it requires AWS CLI installed**.

![ExoplanetAPI in Dcoker](https://github.com/user-attachments/assets/f1f60453-3e68-4706-a992-8ce051882bbb)

## Download
You can find the image in Docker Hub by: https://hub.docker.com/repository/docker/rpairo/exoplanets-api/general

![ExoplanetAPI DockerHub](https://github.com/user-attachments/assets/b2a8a3a0-1ad4-4930-ab93-18af430532de)

## Kubernetes
**I recommend to deploy by [deploy-k8s-resources-easy.sh](k8s/scripts/deploy-k8s-resources-easy.sh). Since will set up everything straigh forward.
You can choose the other ways if you prefer checking the other scripts I made.**

Kubernetes has required beyond investigation, cause as well as in the ExoplanetsAnalyzer project, I am running Kubernetes by Docker Desktop, and this makes not easily to work with.

After further investigations, I have found out the way to solve the missing calls to my running services: port-forwarding.
In /k8s/ directory will find the [deploy-k8s-resources.sh](k8s/scripts/deploy-k8s-resources.sh) file, who has all the logic to set up the ENV VARs, clean up the secrets, deploy the image and if you are using docker, will wait until the service is running to perform the port-forward. It is the only way I have found to be able to reach out the service in kubernetes by docker desktop.

![Running by deploy-k8s-resources-easy.sh](https://github.com/user-attachments/assets/c0810231-5d9d-4496-9316-28fd80ea46f4)
![Kubernetes all](https://github.com/user-attachments/assets/6d0dafa1-5067-4ab3-8d9d-c3252cd0104a)

## Xcode
To run it by xcode, will be important to set up few configurations:
- **ENV VAR**: Xcode will not share the ENV VARs with the OS, they must to be injected by Xcode Scheme.

The path to get this menu is: **Product -> Scheme -> Edit Scheme -> (your-target) -> Arguments**

![](https://github.com/user-attachments/assets/c146473f-71fe-478e-a59e-50f438a02146)

- **Working Directory**: To be able to run properly the server, Vapor recommends to enable the working directory option and set it up pointing to the project root. This option will not shared by xcodes, so it must to be set up manually.
![](https://github.com/user-attachments/assets/86a10b80-d06f-45c6-8ad3-013caf157565)

### Project Structure
The project follows a modular architecture with the following components:
- Domain: Contains core business logic and models.
- Data: Handles data fetching and processing.
- Infrastructure: Manages configurations and external services integration.
- Presentation: Prepares and formats data for API responses.
- Composition: Assembles dependencies and builds the application.
- API: Exposes the endpoints for client interactions.