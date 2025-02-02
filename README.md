# AI Resume Builder & ATS Scoring Application

The **AI Resume Builder & ATS Scoring Application** is a Flask-based API that generates resumes (in DOCX and optionally PDF format) from candidate JSON data and calculates an Applicant Tracking System (ATS) score by comparing the candidate’s skills with the required skills extracted from a job description.

The project supports two ATS scoring methods:
- **Simple Rule-Based Scoring:** Compares candidate skills (extracted from both a dedicated `"skills"` object and experience descriptions) with required skills extracted from the job description.
- **LLM-Enhanced Scoring (Optional):** Uses a locally installed language model (e.g., via the Ollama CLI) to provide a more nuanced ATS score. If the LLM call fails, the system falls back to the simple method.

## Table of Contents

- [Features](#features)
- [Project Structure](#project-structure)
- [Prerequisites](#prerequisites)
- [Installation](#installation)
- [Configuration](#configuration)
- [Usage](#usage)
  - [Running the Application](#running-the-application)
  - [API Endpoints](#api-endpoints)
- [ATS Scoring Logic](#ats-scoring-logic)
- [Interacting with Ollama](#interacting-with-ollama)
- [Debugging and Logging](#debugging-and-logging)
- [License](#license)

## Features

- **Resume Generation:**  
  Generates resume files in DOCX and (optionally) PDF formats from candidate JSON data.

- **ATS Scoring:**  
  Calculates an ATS score based on how well the candidate’s skills match the required skills extracted from a job description.

- **Candidate Skill Extraction:**  
  Collects skills from a dedicated `"skills"` object and scans experience descriptions for mentions of required skills.

- **Required Skill Extraction:**  
  Uses a mapping dictionary to scan the entire job description for known keywords (e.g., mapping `"rest"` to `"rest api"`, `"spark"` to `"apache spark"`, etc.) and produces a standardized list of required skills.

- **LLM Integration (Optional):**  
  Optionally leverages a locally installed language model (via the Ollama CLI) to provide a more nuanced ATS score.

## Project Structure

```
ai-resume-builder/
├── .venv/                           # Virtual environment directory (if used)
├── Dockerfile                       # Docker configuration file (optional)
├── README.md                        # This file
├── config.py                        # Application configuration
├── pyproject.toml                   # Dependency management (if using Poetry)
├── resume_data.json                 # Example candidate data file
├── app.py                           # Flask application entry point
├── static/                          # Static assets (if any)
├── templates/                       # HTML templates for the application
│   ├── index.html                   # Main landing page (for SPA)
│   └── output.html                  # Template to display ATS score and file paths
└── src/
    ├── controller/
    │   └── resume_controller.py     # Flask routes and API endpoints
    ├── model/
    │   └── resume_model.py          # (Optional) Domain models
    ├── repository/
    │   └── resume_repository.py     # (Optional) Data persistence logic
    └── service/
        ├── resume_generator.py      # Module to generate DOCX/PDF resumes
        └── resume_service.py        # ATS scoring and skill extraction logic
```

## Prerequisites

- **Python 3.8+**
- **Flask** for building the API.
- **python-docx** for generating DOCX files.
- **docx2pdf** (optional) for PDF conversion.
- **Requests** library for HTTP calls.
- Optionally, if using Poetry, ensure Poetry is installed.
- If using Ollama for LLM-based scoring:
  - Ollama must be installed on your machine.
  - Familiarity with interacting with Ollama via its CLI.

## Installation

1. **Clone the repository:**

   ```bash
   git clone <repository_url>
   cd ai-resume-builder
   ```

2. **Create and activate a virtual environment (optional):**

   ```bash
   python -m venv .venv
   source .venv/bin/activate  # On Windows: .venv\Scripts\activate
   ```

3. **Install dependencies:**

   Using pip:

   ```bash
   pip install -r requirements.txt
   ```

   Or if using Poetry:

   ```bash
   poetry install
   ```

   *(Ensure your dependency file includes Flask, python-docx, docx2pdf, requests, etc.)*

## Configuration

- **config.py:**  
  Adjust configuration variables as needed (e.g., enable debug mode).

- **Ollama Integration:**  
  If using Ollama, verify that it is installed and accessible via the command line.  
  The code currently uses a CLI call (via `subprocess`) to interact with Ollama. Adjust the command if necessary.

## Usage

### Running the Application

Start the Flask application by running:

```bash
python -m flask run
```

Or, if using a custom entry point:

```bash
python app.py
```

The application will be available at `http://localhost:5000`.

### API Endpoints

- **GET /**  
  Renders the main landing page (useful for a Single-Page Application).

- **POST /api/generate-resume**  
  Accepts a JSON payload with candidate resume data and a job description, then returns:
  - The path to the generated DOCX file.
  - The path to the generated PDF file (if available).
  - The computed ATS score.

Example cURL request:

```bash
curl -X POST http://localhost:5000/api/generate-resume \
     -H "Content-Type: application/json" \
     -d @resume_data.json
```

If `"output_type": "json"` is specified in the payload, the response is in JSON format; otherwise, it renders an HTML page.

## ATS Scoring Logic

1. **Candidate Skill Extraction:**  
   Extracts skills from the `"skills"` object and experience descriptions.

2. **Required Skill Extraction:**  
   Scans the job description for known keywords and maps them to standardized skill names.

3. **Score Calculation:**  
   The ATS score is computed as:

   ```
   ATS Score = (Number of Matching Candidate Skills / Number of Required Skills) * 100
   ```

4. **LLM Integration (Optional):**  
   Optionally, the application calls the Ollama CLI to compute a nuanced score.

## Interacting with Ollama

- The application uses Python's `subprocess` module to execute a command like:

  ```bash
  ollama run llama2 "<your prompt here>"
  ```

- The output from the CLI is parsed to extract a numerical score.
- Adjust the command in `calculate_ats_score_ollama` as needed based on your setup.

## Debugging and Logging

Debugging logs include:
- Extracted candidate skills.
- Extracted required skills from the job description.
- Matching skills between candidate and required skills.
- Output from the Ollama CLI (if used).

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

