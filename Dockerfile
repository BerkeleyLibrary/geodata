# ============================================================================
# Target: base
# Includes system dependencies common to both dev and production.

FROM ruby:3.2.2 AS base

# This is just metadata and doesn't actually "expose" this port. Rather, it
# tells other tools (e.g. Traefik) what port the service in this image is
# expected to listen on.
#
# @see https://docs.docker.com/engine/reference/builder/#expose
EXPOSE 3000

ENV APP_USER=geodata
ENV APP_UID=40012

RUN groupadd --system --gid $APP_UID $APP_USER \
    && useradd --home-dir /opt/app --system --uid $APP_UID --gid $APP_USER $APP_USER

RUN mkdir -p /opt/app \
    && chown -R $APP_USER:$APP_USER /opt/app /usr/local/bundle

# Get list of available packages
RUN apt-get update -qq

# Install standard packages from the Debian repository
RUN apt-get install -y --no-install-recommends \
    bash \
    curl \
    default-jre \
    ca-certificates \ 
    libpq-dev \
    libvips42 \
    &&  rm -rf /var/cache/apk/*

# Install Node.js (using NodeSource to get the latest LTS version, e.g., 20.x)
RUN curl -fsSL https://deb.nodesource.com/setup_20.x| bash - \
    && apt-get install -y --no-install-recommends nodejs

# Install Yarn (using the official Yarn repository)
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
    && echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list \
    && apt-get update && apt-get install -y --no-install-recommends yarn \
    && apt-get clean && rm -rf /var/lib/apt/lists/* 

# By default, run as the geodata user
USER $APP_USER

# All subsequent commands run relative to the app directory.
WORKDIR /opt/app

# Add binstubs to the path.
ENV PATH="/opt/app/bin:$PATH"

# If run with no other arguments, the image will start the rails server by
# default. Note that we must bind to all interfaces (0.0.0.0) because when
# running in a docker container, the actual public interface is created
# dynamically at runtime (we don't know its address in advance).
CMD ["rails", "server", "-b", "0.0.0.0", "--pid", "/tmp/puma.pid"]

# ============================================================================
# Target: development
# Installs all dependencies, requiring the (large) build-base package. Build
# artifacts are copied out in the final stage.
FROM base AS development

# Install system packages needed to build gems with C extensions.
USER root

# Install system packages needed to build gems with C extensions.
RUN apt-get install -y --no-install-recommends \
    gcc \
    g++ \
    make

# Drop back to the GeoData user
USER $APP_USER

# Copy over only the files which are needed to perform a bundle install.
COPY --chown=geodata .ruby-version Gemfile* ./
RUN bundle install

# Copy the rest of the codebase.
COPY --chown=geodata . .

# Create cache/pids/etc directories.
RUN bundle exec -- rails log:clear tmp:create \
    &&  rails assets:precompile

# ============================================================================
# Target: production
#
# Slimmed down, extending the 'base' stage with only the built package from
# the 'development' stage.
FROM base AS production

# Copy the built codebase from the dev stage
COPY --from=development --chown=geodata /opt/app /opt/app
COPY --from=development --chown=geodata /usr/local/bundle /usr/local/bundle

# Sanity-check that the bundle is correctly installed, that the Gemfile
# and Gemfile.lock are synced, and that assets are able to be compiled.
# no need to run bundle install

RUN rails assets:precompile assets:clean log:clear tmp:clear

# Preserve build arguments - from galc

# passed in by CI
ARG BUILD_TIMESTAMP
ARG BUILD_URL
ARG DOCKER_TAG
ARG GIT_REF_NAME
ARG GIT_SHA
ARG GIT_REPOSITORY_URL

# build arguments aren't persisted in the image, but ENV values are
ENV BUILD_TIMESTAMP="${BUILD_TIMESTAMP}"
ENV BUILD_URL="${BUILD_URL}"
ENV DOCKER_TAG="${DOCKER_TAG}"
ENV GIT_REF_NAME="${GIT_REF_NAME}"
ENV GIT_SHA="${GIT_SHA}"
ENV GIT_REPOSITORY_URL="${GIT_REPOSITORY_URL}"