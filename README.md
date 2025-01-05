# Exoplanets API

The [Exoplanets API](https://github.com/rpairo/exoplanets-api) is a Swift-based web service that fetches data from the [ExoplanetAnalyzer](https://github.com/rpairo/exoplanets), processes it, and exposes endpoints to retrieve exoplanet-related information. It is imported as a [library](https://github.com/rpairo/exoplanets/releases/tag/v1.0.12) via Swift Package Manager.

This project also provides a website for a user-friendly navigation experience. Additionally, it integrates the Google Custom Search API to dynamically fetch exoplanet images, addressing the lack of images from sources like NASA and Wikimedia.
- NASA Resources:
	- [API](https://api.nasa.gov)
	- [Image Search](https://images.nasa.gov/)
- Google Custom Search:
	- [Developer Documentation](https://developers.google.com/custom-search)

The API’s JSON models mirror the exoplanet data while including a URL for the exoplanet’s image.

## Endpoints
The server simultaneously provides a website and an API:

### API (JSON Responses)
. **/api/orphans**: Retrieve orphan exoplanets.

. **/api/hottest**: Fetch the exoplanet orbiting the hottest star.

. **/api/timeline**: Get a discovery timeline categorized by exoplanet size.

### Website (HTML Pages)
. **/website/**: Homepage of the exoplanet service.

. **/website/orphans**: View orphan exoplanets.

. **/website/hottest**: See the hottest star’s exoplanet.

. **/website/timeline**: Explore the discovery timeline.

## Visual Examples

### Website
#### /website/
![website-index](https://github.com/user-attachments/assets/68e81179-8401-4553-8c59-3e358f9fec6d)

#### /website/orphans
![website-orphans](https://github.com/user-attachments/assets/defc00f0-b745-4cc4-a748-6099f15d0c84)

#### /website/hottest
![website-hottest](https://github.com/user-attachments/assets/ca940fc4-d4b4-45fb-a0a4-498290d8f841)

#### /website/timeline
![website-timeline](https://github.com/user-attachments/assets/38a6008d-f561-43e0-9346-30546a6cbd3e)


### API (JSON)
#### /api/orphans
![api-orphans](https://github.com/user-attachments/assets/8b2bc416-af59-4741-9693-26a87121147c)

#### /api/hottest
![api-hottest](https://github.com/user-attachments/assets/b8b66bd0-6af6-43a7-b040-a9605a764291)

#### /api/timeline
![api-timeline](https://github.com/user-attachments/assets/e36eeb0f-c700-4173-ac6b-1d911f4923a6)

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

## Frontend with Leaf and Bootstrap
The website is built using Vapor’s Leaf as the templating engine and Bootstrap for responsive and pre-designed components.

### Project Structure
The project follows a modular architecture with the following components:
- Domain: Contains core business logic and models.
- Data: Handles data fetching and processing.
- Infrastructure: Manages configurations and external services integration.
- Presentation: Prepares and formats data for API responses.
- Composition: Assembles dependencies and builds the application.
- API: Exposes the endpoints for client interactions.

### CI/CD
This project also has the same configuration as ExoplanetsAnalyzer](https://github.com/rpairo/exoplanets) in GitHub by Actions to perform the CI/CD flows: Run test, Scan vulnerabilities, Post to Docker Hub.
