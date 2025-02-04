# Geodata

Geodata web portal developed from Geoblacklight 4.4.2
[Geodata@UCB](https://geodata.lib.berkeley.edu/)

## Docker


```sh
# Build container images
docker compose build --pull
# or 
docker compose build --pull --no-cache

# Start the stack in the background
docker compose up --d

# Run setup tasks (create databases, compile assets, etc.)
docker compose run --rm --entrypoint=setup app
```

### Accessing Services

- web: http://localhost:3000
- Solr: http://solr:solr@localhost:8983
- DB Admin: http://localhost:8080

### Configuration

Sensitive settings like the DATABASE_URL, SOLR_URL, and SECRET_KEY_BASE are provided to the application by Docker "secrets". In development, these are stored in `secrets/dev` and you don't have to worry about them. In production, they're provided by the production infrastructure.

Just know that they're there.

The mechanics of loading them into the application are fairly simple:

- Docker puts those in read-only files under `/run/secrets` within the container.
- On startup, the application reads all files in that directory and overrides their corresponding ENV variables. For example, the file `/run/secrets/DATABASE_URL` clobbers the ENV['DATABASE_URL'] environment variable.
- This is preferable to storing that in the _actual_ environment because it ensures _only the Rails process can see that config value_. It's also convenient, though, because you can use ENV to access the value.

If you're curious, the code that does this is in `config/application.rb`.

### Helpful Commands

View logs:

```sh
docker compose logs -f # tail all logs
docker compose logs -f app # tail just the "app" service's logs (etc.)
```

Shell into a container:

```sh
docker compose exec app bash
```

Open a Rails console:

```sh
docker compose exec app rails console
```

Stop services and clean up volumes:

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
