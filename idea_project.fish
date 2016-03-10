#!/usr/local/Cellar/fish/2.2.0/bin/fish
dme
docker exec -it (basename (pwd)) sh
docker exec -it (basename (pwd)) bash
fish