[![Build Status](https://img.shields.io/travis/michael-molchanov/zebra-selenium.svg?style=flat-square)](https://travis-ci.org/michael-molchanov/zebra-selenium)

# Usage

```
docker run --rm -v "$PWD:$PWD" --workdir "$PWD" -e SCREEN_WIDTH="1920" -e SCREEN_HEIGHT="1080" -e SCREEN_DEPTH="24" -e SELENESE_BASE_URL="<URL>" --entrypoint "/opt/bin/entry_point.sh" --shm-size=2g michaeltigr/zebra-selenium-travis:latest "<SUITE>"
```

URL - base site url, e.g https://www.drupal.org

SUITE - suite name
