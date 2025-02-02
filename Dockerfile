# Use an official Python runtime as a parent image
FROM python:3.12-slim

# Set the working directory in the container
WORKDIR /app

# Install system dependencies
RUN apt-get update && apt-get install -y \
    curl \
    build-essential \
    libssl-dev \
    libffi-dev \
    python3-dev && \
    apt-get clean

# Install Poetry
RUN curl -sSL https://install.python-poetry.org | python3 - --version 1.8.2 && \
    ln -s /root/.local/bin/poetry /usr/local/bin/poetry && \
    poetry --version

# Copy only dependency files
COPY pyproject.toml poetry.lock ./

# Debug dependencies installation
RUN poetry config virtualenvs.create false
RUN poetry install --no-interaction --no-ansi -vvv

# Copy application code
COPY . .

# Expose the port
EXPOSE 5000

# Run the application
CMD ["poetry", "run", "flask", "run"]