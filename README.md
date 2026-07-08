![Screenshot of QuakeWatch](static/experts-logo.svg)

# QuakeWatch

**QuakeWatch** is a Flask-based web application designed to display real-time and historical earthquake data. It visualizes earthquake statistics with interactive graphs and provides detailed information sourced from the USGS Earthquake API. Built using an object‑oriented design and modular structure, QuakeWatch separates templates, utility functions, and route definitions, making it both scalable and maintainable. The application is also containerized with Docker for easy deployment.

## Features

- **Real-Time & Historical Data:** Fetches earthquake data from the USGS API.
- **Interactive Graphs:** Displays earthquake counts over various time periods (e.g., last 30 days, 5-year view) using Matplotlib.
- **Top Earthquake Events:** Shows the top 5 worldwide earthquakes (last 30 days) by magnitude.
- **Recent Earthquake Details:** Highlights the most recent earthquake event.
- **RESTful Endpoints:** Provides endpoints for health checks, status, connectivity tests, and raw data.
- **Clean UI:** Built with Bootstrap 5, featuring a professional navigation bar with a logo.
- **Dockerized:** Easily containerized for streamlined deployment.

## Project Structure

```text
QuakeWatch/
├── app/
│   ├── main.py              # Application factory and entry point
│   ├── dashboard.py         # Blueprint & route definitions using OOP style
│   ├── utils.py             # Helper functions and custom Jinja2 filters
│   ├── templates/           # Jinja2 HTML templates
│   │   ├── base.html        # Base template with common layout and navigation
│   │   ├── index.html
│   │   ├── main_page.html   # Home page content
│   │   └── graph_dashboard.html # Dashboard view with graphs and earthquake details
│   └── static/
│       └── experts-logo.svg # Logo file used in the UI
├── k8s/
│   ├── quakewatch-configmap.yaml     # Kubernetes ConfigMap for non-sensitive config
│   ├── quakewatch-crontab.yaml       # Kubernetes CronJob for scheduled tasks
│   ├── quakewatch-deployment.yaml    # Kubernetes Deployment manifest
│   ├── quakewatch-hpa.yaml           # Kubernetes Horizontal Pod Autoscaler
│   ├── quakewatch-secret.yaml        # Kubernetes Secret for sensitive data
│   └── quakewatch-service.yaml       # Kubernetes Service manifest
├── .dockerignore             # Docker ignore file
├── .gitignore                # Git ignore file
├── Dockerfile                # Dockerfile for building production image
├── compose.yaml              # Docker Compose configuration
├── pyproject.toml            # Python project definition
├── requirements.txt          # Python dependencies
├── uv.lock                   # uv lockfile
├── .python-version           # Python version file
└── README.md                 # This README
```

## Installation

### Locally

1. **Clone the Repository:**

   ```bash
   git clone https://github.com/fabian665/QuakeWatch.git
   cd QuakeWatch
   ```

2. **Setup uv environment**

   ```bash
   uv sync
   ```

## Running the Application Locally

1. **Start the Flask Application:**

   ```bash
   QUAKE_PORT=8888 uv run app/main.py
   ```

2. **Access the Application:**

   Open your browser and visit [http://127.0.0.1:8888](http://127.0.0.1:8888) to view the dashboard.

## Docker

### Building the Docker Image

```sh
docker build -t rfabian665/quakewatch .
```

### Running the Image

```sh
docker run --rm --name quakewatch -d -p 8888:8888 rfabian665/quakewatch
```

### Using Docker Compose

```sh
docker compose up --watch
```

## K8s

Deploy to a Kubernetes cluster with the following command:

```sh
kubectl apply -f k8s/
```

Alternatively, apply specific manifests:

```sh
kubectl apply -f k8s/quakewatch-hpa.yaml
kubectl apply -f k8s/quakewatch-secret.yaml
kubectl apply -f k8s/quakewatch-crontab.yaml
kubectl apply -f k8s/quakewatch-service.yaml
kubectl apply -f k8s/quakewatch-configmap.yaml
kubectl apply -f k8s/quakewatch-deployment.yaml
```

### ConfigMap and Secret Management

QuakeWatch uses Kubernetes ConfigMaps and Secrets to manage configuration and sensitive data:

**ConfigMap** (`quakewatch-configmap.yaml`, name `quakewatch-config`):
- Stores non-sensitive configuration values
- Contains `quake_port: "8888"` — the port on which the application listens
- Injected into the Deployment and CronJob via `configMapKeyRef`

**Secret** (`quakewatch-secret.yaml`, name `quakewatch-secret`, type `Opaque`):
- Stores sensitive data: `flask_secret_key` used by Flask to sign session cookies
- Injected as the `FLASK_SECRET_KEY` environment variable via `secretKeyRef`
- Read by `main.py:13` as `app.config['SECRET_KEY'] = os.getenv('FLASK_SECRET_KEY')`

**Important:** Committing a real secret value to version control is only acceptable for this course exercise. In production, create secrets out-of-band using `kubectl create secret generic ...` or a secrets manager, and keep the manifest out of version control.

## Custom Jinja2 Filter

The project includes a custom filter `timestamp_to_str` that converts epoch timestamps to human-readable strings. This filter is registered during application initialization and is used in the templates to format earthquake event times.

## Known Issues

- **SSL Warning:** You might see a warning regarding LibreSSL when using urllib3. This is informational and does not affect the functionality of the application.
- **Matplotlib Backend:** The application forces Matplotlib to use the `Agg` backend for headless rendering. Ensure this setting is applied before any Matplotlib imports to avoid GUI-related errors.
