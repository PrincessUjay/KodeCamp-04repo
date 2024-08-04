# Base image from the official Python repository
FROM python:3.9-slim

# Set the working directory within the container
WORKDIR /app

# Copy all application files
COPY app.py .

# Expose port 8000
EXPOSE 8000

# Command to run the application
CMD ["python", "app.py"]
