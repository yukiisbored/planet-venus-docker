#!/bin/sh

PLANET_DIRECTORY=/planet
PLANET_CONFIG_FILE=/planet/planet.ini

# Change working directory to planet's directory
cd "$PLANET_DIRECTORY"

# Generate pages
exec planet --verbose "$PLANET_CONFIG_FILE"
