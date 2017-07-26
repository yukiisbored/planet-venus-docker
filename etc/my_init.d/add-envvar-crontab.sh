#!/bin/sh

printenv | grep "^PLANET" | sed 's/^\(.*\)$/export \1/g' > /etc/planet_env
chmod +x /etc/planet_env
