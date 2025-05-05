# Use multi-stage builds for a smaller and more secure image
# -------------------- Builder Stage --------------------
    FROM python:3.11.4-slim-buster AS builder

    WORKDIR /build
    
    # Install build dependencies
    RUN apt-get update -y && apt-get install -y --no-install-recommends \
        build-essential \
        libffi-dev \
        libssl-dev
    
    # Copy requirements and install dependencies
    COPY requirements.txt .
    RUN pip install --upgrade pip && \
        pip install --no-cache-dir -r requirements.txt
    
    # -------------------- Final Stage --------------------
    # Use a distroless base image for the smallest possible runtime
    FROM python:3.11.4-slim-buster
    
    WORKDIR /app
    
    # Copy only the necessary application files from the builder
    COPY --from=builder /usr/local/lib/python3.11/site-packages /usr/local/lib/python3.11/site-packages
    
    # Copy application code.
    COPY . /app
    # Create a non-root user and group for enhanced security
    RUN groupadd --gid 1000 appuser
    RUN useradd --uid 1000 --gid appuser --shell /sbin/nologin appuser
    
    # Set the correct permissions for the application directory
    RUN chown -R appuser:appuser /app
    
    # Switch to the non-root user to run the application
    USER appuser
    
    EXPOSE 7549
    
    # Standard Python execution.  Secrets must be provided
    # through some other mechanism (e.g., environment variables).
    CMD ["python", "app.py"]
    