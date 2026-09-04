# GeoData

GeoData is UC Berkeley Library's geospatial data portal, built with GeoBlacklight 5.3.

[Geodata@UCB](https://geodata.lib.berkeley.edu/)

## Docker development

Install Docker with the Compose plugin before starting. Docker Compose automatically
uses `compose.yml` for local development; `compose.ci.yml` is an overlay used by the
GitHub Actions workflow.

### Start the stack

```sh
# Build container images
docker compose build --pull

# Start the stack in the background
docker compose up -d
```

On startup, the one-shot `updater` service waits for PostgreSQL and Solr, prepares
the development database, builds CSS, and seeds Solr. The `app` service starts only
after the updater exits successfully.

Check startup status and troubleshoot initialization with:

```sh
docker compose ps
docker compose logs updater db solr

# Rerun initialization when needed
docker compose run --rm updater

# Run db setup in test ENV
docker compose run --rm -e RAILS_ENV=test app rails db:setup
```

### Accessing services

- GeoData: http://localhost:3000
- Solr Admin: http://localhost:8983/solr/
- PostgreSQL: `localhost:5432` (`root` / `root`)

### Configuration

Local database, Solr, and Rails environment settings are defined in `compose.yml`.
`RAILS_ENV` defaults to `development` and can be overridden from the shell.

The application also supports secrets mounted as files under `/run/secrets`. At
startup, each nonempty file is loaded into an environment variable named after the
file, but only when that variable is not already set. Explicit environment variables
therefore take precedence over mounted secrets.

The GeoBlacklight map basemap provider defaults to `openstreetmapStandard` and can be
overridden by setting the `GEOBLACKLIGHT_BASEMAP_PROVIDER` environment variable (see
`app/controllers/catalog_controller.rb` for the list of providers).

### CSS development

The updater performs the initial CSS build. Rebuild after changing stylesheets, or
run the watcher while actively developing CSS:

```sh
# One-time rebuild
docker compose exec app rails css:build

# Continuous rebuilds; stop with Ctrl-C
docker compose exec app yarn watch:css
```

### Helpful commands

```sh
# Follow logs for every service or only the Rails application
docker compose logs -f
docker compose logs -f app

# Open a shell or Rails console
docker compose exec app bash
docker compose exec app rails console
```

Build the deployable `final` image. Production asset compilation and smoke tests run
as part of this build:

```sh
docker build --target final -t geodata .
```

Stop and resume the existing containers while preserving their local state:

```sh
docker compose stop
docker compose start
```

Stop the stack and delete its local database, Solr data, and other volumes:

```sh
docker compose down -v
```

## Deployment

### Staging

- GeoData: https://geodata.ucblib.org/
- Solr: https://solr.ucblib.org
- GeoServer Public (not in stack): https://geoserver-public.ucblib.org/
- GeoServer Secure (not in stack): https://geoserver-secure.ucblib.org/

### Production

- GeoData: https://geodata.lib.berkeley.edu/
- Solr: https://solr.swarm-ewh-prod.devlib.berkeley.edu/
- GeoServer Public (not in stack): https://geoservices.lib.berkeley.edu/
- GeoServer Secure (not in stack): https://geoservices-secure.lib.berkeley.edu/
