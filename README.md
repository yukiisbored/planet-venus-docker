# planet-venus Docker Image

This is a docker image for planet-venus. This image is created to make deployment
of planet-venus easier. This image also contains `lighttpd` as the web server,
because planet-venus it self is a static page generator.

A cron daemon with a crontab has been setup to update the pages every 30 mins

## Environment variables reference

| Variable             | Description                                | Default             |
|----------------------|--------------------------------------------|---------------------|
| `PLANET_DIRECTORY`   | The directory for the planet configuration | `/planet`           |
| `PLANET_CONFIG_FILE` | The configuration file for the planet      | `/planet/planet.ini |
| `PLANET_OUTPUT`      | The HTML output for the planet             | `/planet/output`    |

## How to use?

### With vendored configuration images

Currently, the image comes with the default planet configuration, we recommend
adding your planet by creating a `Dockerfile` and using this image as the base,
like this:

```Dockerfile
FROM yukiisbored/planet-venus

COPY crontab /etc/crontab
COPY my-awesome-planet /planet
```

The reason why this is a preferable way is because it'll easy to transfer than
having externally defined volumes. With this, you can just start the image
without a lot of configuration.

### With defined external volumes

If you prefer using external volumes, you can defined volumes for your planet
configuration with Compose or the docker command directly:

**docker-compose.yml**

```yaml
version: '2'
services:
  planet:
    image: yukiisbored/planet-venus
    volume:
      - ./my-awesome-planet:/planet
```

**`docker` command**

`docker run -v ./my-awesome-planet:/planet yukiisbored/planet-venus`

If you're using another directory, You can use the `PLANET_DIRECTORY`,
`PLANET_CONFIG_FILE`, and `PLANET_OUTPUT` environment variables:

**docker-compose.yml**

```yaml
version: '2'
services:
  planet:
    image: yukiisbored/planet-venus
    volume:
      - ./my-awesome-planet:/my-awesome-planet
    environment:
      - PLANET_DIRECTORY=/my-awesome-planet
      - PLANET_CONFIG_FILE=/my-awesome-planet/config.ini
      - PLANET_OUTPUT=/my-awesome-planet/output
```
