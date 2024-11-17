#basic image, alpine is a lightweight version of python
FROM python:3.9-alpine3.13 
#maintainer label, any name can be used
LABEL maintainer="nhatviet253"

#logging to the console in real time, not buffering
ENV PYTHONUNBUFFERED 1

#copying the requirements file to the image
COPY ./requirements.txt /tmp/requirements.txt
COPY ./requirements.dev.txt /tmp/requirements.dev.txt
#copy the app folder to the image
COPY ./app /app
# set the working directory
WORKDIR /app
EXPOSE 8000

ARG DEV=true
# Install PostgreSQL client and development files
RUN apk add --update --no-cache postgresql-client && \
    apk add --update --no-cache --virtual .tmp-build-deps \
        build-base postgresql-dev musl-dev libffi-dev && \
    # Create virtual environment
    python -m venv /py && \
    # Upgrade pip
    /py/bin/pip install --upgrade pip && \
    # Install the required packages
    /py/bin/pip install -r /tmp/requirements.txt && \
    # If dev is true, install the dev requirements
    if [ $DEV = "true" ]; \
        then /py/bin/pip install -r /tmp/requirements.dev.txt ;\
    fi && \
    # Remove the requirements file
    rm -rf /tmp && \
    # Remove temporary build dependencies
    apk del .tmp-build-deps && \
    # Add a user to run the app
    adduser \
        --disabled-password \
        --no-create-home \
        django-user

# Set environment variable for the virtual environment
ENV PATH="/py/bin:$PATH"

# Switch to the new user
USER django-user