# Use a more secure Python base image
#FROM python:3.9-slim-bookworm AS builder
#FROM python:3.9-slim
FROM python:3.11-slim-bullseye
# Set environment variables
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

# Update OS packages before installing dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    zlib1g-dev && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Install dependencies
WORKDIR /app
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy the application code
COPY . .

# Use a non-root user
RUN useradd -m myuser
USER myuser

# Expose the port the app runs on
EXPOSE 8000

# Run the application
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000"]

