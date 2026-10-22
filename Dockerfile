# Use a slim Python 3.9 base image
FROM python:3.9-slim

# Set the working directory
WORKDIR /app

# Install dependencies first so Docker can cache this layer
COPY requirements.txt .
RUN pip install --upgrade pip && \
    pip install -r requirements.txt

# Copy the application code
COPY service/ ./service/

# Run as a non-root user
RUN useradd --uid 1000 theia && chown -R theia /app
USER theia

# The service listens on port 8080
EXPOSE 8080

# Start the app with gunicorn
CMD ["gunicorn", "--bind=0.0.0.0:8080", "--log-level=info", "service:app"]
