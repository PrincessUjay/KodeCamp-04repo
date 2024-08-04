# Base image from the official Python repository
FROM python:3.10-alpine

# Set the working directory within the container
WORKDIR /app

# Copy all application files
COPY . /app

# Install Flask
RUN pip install --no-cache-dir -r requirements.txt

# Expose port 5000
EXPOSE 5000

# Define environment variable
ENV NAME World

# Command to run the application
CMD ["python", "app.py"]
