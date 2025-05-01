# Use official Python image
FROM python:3.11-slim

# Set environment variables
ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

# Set working directory inside container
WORKDIR /myproject

# Install system dependencies
RUN apt-get update && apt-get install -y \
    libpq-dev gcc curl netcat && \
    apt-get clean

# Install Python dependencies
COPY requirements.txt .
RUN pip install --upgrade pip && pip install -r requirements.txt

# Copy all project files
COPY . .

# Expose Django port
EXPOSE 8000

# Default command can be overridden in Jenkins
CMD ["python", "manage.py", "runserver", "0.0.0.0:8000"]