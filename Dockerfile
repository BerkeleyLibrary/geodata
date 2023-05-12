# ============================================================================
# Target: base
# Includes system dependencies common to both dev and production.

FROM ruby:3.2.2-alpine3.17 AS base

# This is just metadata and doesn't actually "expose" this port. Rather, it
# tells other tools (e.g. Traefik) what port the service in this image is
# expected to listen on.
#
# @see https://docs.docker.com/engine/reference/builder/#expose
EXPOSE 3000

RUN addgroup -S -g 40012 geodata \
&&  adduser -S -u 40012 -G geodata geodata \
&&  install -o geodata -g geodata -d /opt/app \
&&  chown -R geodata:geodata /opt \
&&  chown -R geodata:geodata /opt/app  /usr/local/bundle

RUN apk --no-cache --update upgrade \
&&  apk --no-cache add \
        bash \
        ca-certificates \
        git \
        libc6-compat \
        nodejs \
        openssl \
        postgresql-libs \
        sqlite-libs \
        shared-mime-info \
        tzdata \
        xz-libs \
&&  rm -rf /var/cache/apk/*

RUN apk update && apk add -u yarn

# # Replace the default 1.x bundler with 2.x, as required by this bundle. - no need for geoblacklight 3.1
# RUN yes | gem uninstall --force -i /usr/local/lib/ruby/gems/2.5.0 bundler \
# &&  gem install -i /usr/local/lib/ruby/gems/2.5.0 --version=2.0.1 bundler
# ENV BUNDLER_VERSION='2.0.1'

# By default, run as the geodata user
USER geodata

# All subsequent commands run relative to the app directory.
WORKDIR /opt/app

# Add binstubs to the path.
ENV PATH "/opt/app/bin:$PATH"


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
RUN apk --update --no-cache add \
        build-base \
        coreutils \
        postgresql-dev \
        curl \
        sqlite-dev

# Drop back to the GeoData user
USER geodata

# Copy over only the files which are needed to perform a bundle install.
COPY --chown=geodata .ruby-version Gemfile* ./
RUN bundle install

# Copy the rest of the codebase.
COPY --chown=geodata . .

# Create cache/pids/etc directories.
RUN bundle exec -- rails log:clear tmp:create \
&&  rails assets:precompile
RUN mkdir tmp/cache/downloads

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
RUN bundle lock --add-platform x86-mingw32 x86-mswin32 x64-mingw32 java \
&&  rails assets:precompile assets:clean log:clear tmp:clear
RUN mkdir tmp/cache/downloads


# Preserve build arguments - from galc

# passed in by CI
ARG BUILD_TIMESTAMP
ARG BUILD_URL
ARG DOCKER_TAG
ARG GIT_BRANCH
ARG GIT_COMMIT
ARG GIT_URL

# build arguments aren't persisted in the image, but ENV values are
ENV BUILD_TIMESTAMP="${BUILD_TIMESTAMP}"
ENV BUILD_URL="${BUILD_URL}"
ENV DOCKER_TAG="${DOCKER_TAG}"
ENV GIT_BRANCH="${GIT_BRANCH}"
ENV GIT_COMMIT="${GIT_COMMIT}"
ENV GIT_URL="${GIT_URL}"
