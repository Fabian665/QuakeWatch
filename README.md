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
├── Dockerfile               # Dockerfile to for building production image
├── Dockerfile.dockerignore  # Dockerfile ignore
├── README.md                # This README
├── dashboard.py             # Blueprint & route definitions using OOP style
├── main.py                  # Application factory and entry point
├── utils.py                 # Helper functions and custom Jinja2 filters
├── pyproject.toml           # Python project definiton
├── requirements.txt         # Python dependencies
├── static/
│   └── experts-logo.svg     # Logo file used in the UI
├── templates/               # Jinja2 HTML templates
│   ├── base.html            # Base template with common layout and navigation
│   ├── index.html
│   ├── main_page.html       # Home page content
│   └── graph_dashboard.html # Dashboard view with graphs and earthquake details
└── uv.lock                  # uv lockfile
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
   uv run main.py
   ```

2. **Access the Application:**

   Open your browser and visit [http://127.0.0.1:5000](http://127.0.0.1:5000) to view the dashboard.

## Docker

### Building the Docker Image

```sh
docker build -t quakewatch .
```

### Running the Image

```sh
docker run --rm --name quakewatch -d -p 5000:5000 quakewatch
```

### Using Docker Compose

```sh
docker compose up --watch
```

## Custom Jinja2 Filter

The project includes a custom filter `timestamp_to_str` that converts epoch timestamps to human-readable strings. This filter is registered during application initialization and is used in the templates to format earthquake event times.

## Known Issues

- **SSL Warning:** You might see a warning regarding LibreSSL when using urllib3. This is informational and does not affect the functionality of the application.
- **Matplotlib Backend:** The application forces Matplotlib to use the `Agg` backend for headless rendering. Ensure this setting is applied before any Matplotlib imports to avoid GUI-related errors.
