# FastAPI App for Azure

This is a basic FastAPI application designed to be deployed on Azure. It includes a simple "Hello World" endpoint, a `/status` endpoint, and a `/health` endpoint that provides system metrics.

## Project Structure

- `main.py`: The main FastAPI application file, defining the endpoints and integrating Jinja2 templates.
- `requirements.txt`: Lists the Python dependencies required for the application.
- `templates/`: Directory containing HTML templates for the web interface.
    - `index.html`: The main page displaying "Hello World" and links to status/health.
    - `health.html`: Displays detailed health metrics (CPU, memory, disk usage).
- `Dockerfile`: Defines the Docker image for containerizing the application.
- `.gitignore`: Specifies files and directories to be ignored by Git.
- `static/`: Directory containing static files like CSS.
    - `style.css`: Provides basic styling for the HTML pages.

## Endpoints

- `/`: A basic "Hello World" page rendered using Jinja2.
- `/status`: Returns a JSON response indicating the application's status (e.g., `{"status": "ok"}`).
- `/health`: Returns an HTML page displaying real-time CPU usage, memory information, and disk space.

## Setup and Local Development

1.  **Clone the repository:**
    ```bash
    git clone https://github.com/YOUR_USERNAME/YOUR_REPOSITORY_NAME.git
    cd FastAPIAppforAzure
    ```
2.  **Create a virtual environment and install dependencies:**
    ```bash
    python -m venv venv
    source venv/bin/activate  # On Windows use `venv\Scripts\activate`
    pip install -r requirements.txt
    ```
3.  **Run the application:**
    ```bash
    uvicorn main:app --reload
    ```
    The application will be accessible at `http://127.0.0.1:8000`.

## Styling

A basic `style.css` is included in the `static/` directory to provide a cleaner look for the HTML pages.

## Docker

To build and run the application using Docker:

1.  **Build the Docker image:**
    ```bash
    docker build -t fastapi-azure-app .
    ```
2.  **Run the Docker container:**
    ```bash
    docker run -p 80:80 fastapi-azure-app
    ```
    The application will be accessible at `http://localhost:80`.

## Deployment to Azure

This application can be deployed to various Azure services, such as Azure App Service (Web Apps for Containers), Azure Container Apps, or Azure Kubernetes Service (AKS).

**Example for Azure App Service (Web Apps for Containers):**

1.  **Log in to Azure CLI:**
    ```bash
    az login
    ```
2.  **Set your subscription (if you have multiple):**
    ```bash
    az account set --subscription "Your Subscription Name or ID"
    ```
3.  **Create a resource group:**
    ```bash
    az group create --name MyFastAPIGroup --location eastus
    ```
4.  **Create an Azure Container Registry (ACR) (if you don't have one):**
    ```bash
    az acr create --resource-group MyFastAPIGroup --name myfastapiappacr --sku Basic --admin-enabled true
    ```
5.  **Log in to your ACR:**
    ```bash
    az acr login --name myfastapiappacr
    ```
6.  **Tag and push your Docker image to ACR:**
    ```bash
    docker tag fastapi-azure-app myfastapiappacr.azurecr.io/fastapi-azure-app:latest
    docker push myfastapiappacr.azurecr.io/fastapi-azure-app:latest
    ```
7.  **Create an App Service Plan:**
    ```bash
    az appservice plan create --name MyFastAPIPlan --resource-group MyFastAPIGroup --sku B1 --is-linux
    ```
8.  **Create a Web App for Containers:**
    ```bash
    az webapp create --resource-group MyFastAPIGroup --plan MyFastAPIPlan --name myfastapiapp --deployment-container-image-name myfastapiappacr.azurecr.io/fastapi-azure-app:latest
    ```
9.  **Configure the Web App to use the correct port (80):**
    ```bash
    az webapp config appsettings set --resource-group MyFastAPIGroup --name myfastapiapp --settings WEBSITES_PORT=80
    ```

Your application will be accessible at `https://myfastapiapp.azurewebsites.net`.