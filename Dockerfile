FROM python:3.11-slim

# Set the working directory
WORKDIR /myproject

# Install system dependencies
RUN apt-get update && apt-get install -y \
    libpq-dev gcc curl netcat-openbsd && \
    apt-get clean

# Install Python dependencies
COPY requirements.txt .
RUN pip install --upgrade pip && pip install -r requirements.txt

# Copy all project files
COPY . .

# Expose Django port
EXPOSE 8081

# Default command can be overridden in Jenkins
CMD ["python", "manage.py", "runserver", "0.0.0.0:8081"]