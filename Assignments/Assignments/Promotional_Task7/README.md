# Create, Containerize, and Deploy a simple web application using Docker and Kubernetes.

## Overview
This project demonstrates the creation, containerization, and deployment of a simple web application using Docker and Kubernetes. The application displays a message: "Hello, Welcome to KodeCamp DevOps Bootcamp!". This guide includes all the necessary steps from setting up your environment to deploying your application on a Minikube cluster.

NOTE:
* The application uses Python's built-in `http.server` module to serve a simple webpage.
* The application is containerized using Docker. The Dockerfile is used to build the Docker image.
* The application is deployed to a Kubernetes (Minikube)cluster using a Deployment and a Service.

### Prerequisites
* Install Docker: Check the Docker Installation Guide
* Install Minikube: Check the Minikube Installation Guide
* Install Git: Check the Git Installation Guide
* Create a Docker Hub Account: Docker Hub
* Install Python

## Steps
### Step 1: Create a Simple Web Application
* Create a Project Directory then enter the directory 
      
       mkdir promotional_task7
       cd promotional_task7
* Create a Readme file (You will edit this later with your steps)

       echo “my readme file” > README.md
* Create the Application File: Create a file named app.py 
    
       touch app.py
* Write the following content in the file:

      from http.server import SimpleHTTPRequestHandler, HTTPServer

      class MyHandler(SimpleHTTPRequestHandler):
          def do_GET(self):
              self.send_response(200)
              self.send_header("Content-type", "text/html")
              self.end_headers()
              self.wfile.write(b"Hello, Welcome to KodeCamp DevOps Bootcamp!")

      def run(server_class=HTTPServer, handler_class=MyHandler):
          server_address = ('', 8000)
          httpd = server_class(server_address, handler_class)
          print("Starting httpd server on port 8000...")
          httpd.serve_forever()

      if __name__ == "__main__":
          run()

### Step 2: Dockerize the Application
* Create a Dockerfile

       touch dockerfile
* Write the following content in the file:
      
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
* Build the Docker Image
Open a terminal and run:

      docker build -t promotional_task7/myfirstpythonapp:0.0.1.RELEASE .
* Run the Docker Container Locally

      docker container run -d -p 8000:8000 promotional_task7/myfirstpythonapp:0.0.1.RELEASE
* Test the Application
Open a browser and go to http://localhost:8000 to see the message "Hello, Welcome to KodeCamp DevOps Bootcamp!".

Or

Run this command to see the details of the container

      docker container ls 
* Tag and Push the Docker Image to Docker Hub

      docker tag promotional_task7/myfirstpythonapp:0.0.1.RELEASE princessujay/myfirstpythonapp:0.0.1.RELEASE
   * Log in to Docker Hub

          docker login
N/b: you’ll be prompted to input your login credentials or it’ll authenticate with existing credentials and then show Login Succeeded. 
   * Push the image to Docker Hub

         docker push princessujay/myfirstpythonapp:0.0.1.RELEASE

### Step 3: Deploy the Application to a Kubernetes Cluster
* Start Minikube

       minikube start
* Kubernetes Deployment Manifest

Create a file named deployment.yaml 

      touch deployment.yaml
add the following content to the file:

      apiVersion: apps/v1
      kind: Deployment
      metadata:
        name: myfirstpythonapp
      spec:
        replicas: 1
        selector:
          matchLabels:
            app: myfirstpythonapp
        template:
          metadata:
            labels:
              app: myfirstpythonapp
          spec:
            containers:
            - name: myfirstpythonapp
              image: princessujay/myfirstpythonapp:0.0.1.RELEASE
              ports:
              - containerPort: 8000
* Kubernetes Service Manifest

Create a file named service.yaml
    
      touch service.yaml
add the following content to the file:

      apiVersion: v1
      kind: Service
      metadata:
        name: myfirstpythonapp
      spec:
        type: ClusterIP
        selector:
           app: myfirstpythonapp
        ports:
          - protocol: TCP
            port: 80
            targetPort: 8000
* Apply the Deployment and Service

      kubectl apply -f deployment.yaml
      kubectl apply -f service.yaml

### Step 4: Test the Deployment
* Verify the Deployment and Service

      kubectl get deployments
      kubectl get services

* Port-Forward the Service to Localhost

      kubectl port-forward service/myfirstpythonapp 8080:80

N/b: Access the application in your web browser at http://localhost:8080. You should see the message "Hello, Welcome to KodeCamp DevOps Bootcamp!".

## BONUS: CONFIGMAP & SECRET
### Step 5: Configmap
* Create a file named configmap.yaml

      touch configmap.yaml
Add the following contents to the file:

      apiVersion: v1
      kind: ConfigMap
      metadata:
        name: app-config
      data:
        WELCOME_MESSAGE: "Hello, Kubernetes!"

### Step 6: Secret
* Create a file named secret.yaml

      touch secret.yaml
Add the following contents to the file:

      apiVersion: v1
      kind: Secret
      metadata:
        name: app-secret
      type: Opaque
      data:
        SECRET_PASSWORD: cGFzc3dvcmQ= #base64_encoded_password

### Step 7: Update ‘app.py’ to Use ConfigMap and Secret:

      import os
      from http.server import SimpleHTTPRequestHandler, HTTPServer

      class MyHandler(SimpleHTTPRequestHandler):
          def do_GET(self):
              welcome_message = os.getenv('WELCOME_MESSAGE', "Hello, Welcome to KodeCamp DevOps Bootcamp!")
              secret_password = os.getenv('SECRET_PASSWORD', "No Secret")
              self.send_response(200)
              self.send_header("Content-type", "text/html")
              self.end_headers()
              self.wfile.write(f"{welcome_message}. Secret Password: {secret_password}".encode())

      def run(server_class=HTTPServer, handler_class=MyHandler):
          server_address = ('', 8000)
          httpd = server_class(server_address, handler_class)
          print("Starting httpd server on port 8000...")
          httpd.serve_forever()

      if __name__ == "__main__":
          run()
### Step 8: Update deployment.yaml to Use ConfigMap and Secret:

      apiVersion: apps/v1
      kind: Deployment
      metadata:
        name: myfirstpythonapp
      spec:
        replicas: 1
        selector:
          matchLabels:
            app: myfirstpythonapp
        template:
          metadata:
            labels:
              app: myfirstpythonapp
          spec:
            containers:
            - name: myfirstpythonapp
              image: princessujay/myfirstpythonapp:0.0.1.RELEASE
              ports:
              - containerPort: 8000
              env:
              - name: WELCOME_MESSAGE
                valueFrom:
                  configMapKeyRef:
                    name: app-config
                    key: WELCOME_MESSAGE
              - name: SECRET_PASSWORD
                valueFrom:
                  secretKeyRef:
                    name: app-secret
                    key: SECRET_PASSWORD

### Step 9: Apply the ConfigMap and Secret:

      kubectl apply -f configmap.yaml
      kubectl apply -f secret.yaml
      kubectl apply -f deployment.yaml

### Step 10: Test the Deployment
Port-forward the service to access it locally:

      kubectl port-forward service/myfirstpythonapp 8080:80

Now, access the application in your web browser at http://localhost:8080. You should see a message similar to "Hello, Kubernetes! Secret Password: password".

* Push Code to GitHub Repo

      git add .
      git commit -m "Initial commit"
      git push 
### Screenshots
Include screenshots of your application running, Docker image, and Kubernetes deployment.

### Docker Image URL
https://hub.docker.com/r/princessujay/myfirstpythonapp

### Issues and Resolutions
* issue 1
  
      ERROR: failed to solve: python:3.9-slim: failed to resolve source metadata for docker.io/library/python:3.9-slim: failed to copy: httpReadSeeker: failed open: failed to do request: Get "https://production.cloudflare.docker.com/registry-v2/docker/registry/v2/blobs/sha256/2/c21985b6cbb254ablc851bfcf403484205c5725a418376d1613f2b1255f/data?verify=1722815884-hkqJOclho3qVpGLOtV26BWsGwiQ%3D": net/http: TLS handshake timeout
The error message indicated a timeout issue when Docker is trying to pull the python:3.9-slim image from Docker Hub. This happened due to network issues, connectivity problems, but it was not  temporary issues with Docker Hub.
    * Resolution: Ensured that internet connection is stable and there are no interruptions.
* issue 2
![image](https://github.com/user-attachments/assets/62b99190-bf54-4d48-a829-6aea2f9960cc)
    * Resolution: This part indicates that Minikube tried to find an existing Docker machine named "minikube" but couldn't find it. This is Not really an issue because Minikube will create a new machine if it doesn't find an existing one. I included it just incase you encounter it.
 
* issue 3
![image](https://github.com/user-attachments/assets/8274ccd3-7c3e-4fbf-9ea6-c3a6c65d0493)
    * Resolution1: Enable virtualization in BIOS

         Steps to follow:
      
          * Restart Your Computer: Restart your computer and enter the BIOS setup. This is usually done by pressing a key such as F2, F10, F12, Del, or Esc immediately after turning on your computer. The specific key can vary depending on your computer manufacturer.
          * Enter BIOS Setup: Look for an option related to CPU, processor, or system configuration. The exact location and name of the setting may vary, but it’s often found under tabs like Advanced, Advanced BIOS Features, Processor Configuration, or System Configuration.
          * Enable Virtualization: Find and enable the setting labeled Intel VT-x, Intel Virtualization Technology, Vanderpool, AMD-V, or SVM. Enable this option.
          * Save and Exit BIOS: Save your changes and exit the BIOS setup. This is usually done by pressing F10, but the exact key may vary. Your computer will restart.
          * Verify Virtualization is Enabled.
             - Open Task Manager: Open Task Manager by pressing Ctrl + Shift + Esc or right-clicking the taskbar and selecting Task Manager.
             - Check Virtualization Status: Go to the Performance tab and look for the Virtualization status. It should say Enabled.
          * Retry Minikube: Once virtualization is enabled in your BIOS, try starting Minikube again: run minikube start
    * Resolution2: Use Docker Driver

      If you continue to have issues with VirtualBox, you can use the Docker driver instead, provided Docker is installed and running on your machine:

To Start Minikube with Docker Driver run:
          
          minikube start --driver=docker
N/B: Ensure that Docker Desktop is installed and running on your machine if you opt for the Docker driver. This approach avoids the need for enabling hardware virtualization in BIOS.
