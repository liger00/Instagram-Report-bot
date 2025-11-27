# Use an official Python runtime as a parent image
FROM python:3.9-slim

# Prevent Python from writing .pyc files and enable unbuffered logs
ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1

# Set the working directory in the container
WORKDIR /app

# Install system dependencies (optional but helps with some Python packages)
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    && rm -rf /var/lib/apt/lists/*

# Copy only requirements first to leverage Docker layer caching
COPY requirements.txt /app/

# Install Python dependencies
# IMPORTANT: requirements.txt MUST NOT contain "sys" (remove that line if it exists)
RUN python -m pip install --upgrade pip && \
    pip install --no-cache-dir -r requirements.txt

# Copy the rest of the application code
COPY . /app/

# Expose port 8080 for your Flask app
EXPOSE 8080

# Run the main script when the container launches
# Make sure main.py is at the root of your project and starts the Flask app
CMD ["python", "main.py"]
