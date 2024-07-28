# docker-palworld-server

This docker image provides a PalWorld server and some features to operate it easily.
You can run and host the PalWorld server on a container.

The docker image is built as multi architecture image and will work on the following:

- [x] linux/arm64
- [x] linux/amd64

## Getting started

Execute the following command on your host machine.

```bash
docker container run --rm -d \
    -v $(pwd)/palworld:/palworld \
    -p 8211:8211/udp \
    ghcr.io/octarect/docker-palworld-server:latest
```

## Configuration

WIP

For your reference, see [PalWorldSettings.ini.tmpl](./tools/confgen/templates/PalWorldSettings.ini.tmpl).

## License

[MIT license](./LICENSE)
