<div align="center">

[![oskar barcz / adsb-receiver-api][banner]][homepage]

The ADS-B receiver server component for the [**MyPreflight**][homepage] platform. It listens for position reports over
HTTP, from flight-simulator-based transponders.

</div>

## About

**MyPreflight** is a briefing service and electronic flight board app for your virtual flights, providing you realistic
figures, checklists, procedures and data to perform your flight like a real pilots do. You can customize your
experience, integrate with SimBrief and other tools. Check out our homepage at [mypreflight.io][homepage].

**This module** is the ground station. Real ADS-B receiver listens to 1090 MHz, and this one listens to HTTP:

- accepts position reports from the [transponder app][transponder-repo] running on a player's PC,
- keeps the track of every callsign in memory, ordered by time,
- serves that track to anything that wants to process these data.

It is as close as it gets **ADS-B over HTTP** implementation.

[![release][release-badge]][release-url]
[![license][license-badge]][license-url]

### Built with

[![TypeScript][ts-badge]][ts-url]
[![Node.js][node-shield]][node-url]
[![NestJS][nest-badge]][nest-url]
[![Docker][docker-badge]][docker-url]

No database. Positions live in a `cache-manager` store keyed by callsign, so the receiver restarts empty — exactly like
a real one does when you power-cycle it.

## Getting started

### Environment

This app uses docker-based virtualization to run. To set up the project, follow these steps:

1. Clone the project by running:

    ```shell
    git clone git@github.com:mypreflight/adsb-receiver-api.git
    ```

2. Prepare an environment variable file by copying `.env.dist` to `.env` and fill it with your data.

    ```shell
    cd adsb-receiver-api
    cp .env.dist .env
    ```

3. Use docker compose to set up the environment

    ```shell
    docker compose up -d --build
    ```

    Packages and dependencies will be configured automatically.

4. Your project should be up and running. Open the browser and go to [http://localhost/api](http://localhost/api) to see
   the api documentation. You can preview app logs by running:

    ```shell
    docker compose logs -f app
    ```

> **Do not execute NPM or any other commands regarding project from your host machine, use container shell instead.**
> For example, to lint the project run:
>
> ```shell
> docker compose exec app npm run lint
> ```

To shut the containers down run:

```shell
docker compose down
```

### Authorization

There are two bearer tokens, both set in `.env`. There are no user accounts and nothing is persisted.

| Token          | Who holds it        | What it unlocks                        |
| -------------- | ------------------- | -------------------------------------- |
| `CLIENT_TOKEN` | the transponder app | publishing position reports            |
| `ADMIN_TOKEN`  | the platform        | clearing the track of a given callsign |

Reading a track needs no token at all — a real ADS-B signal is not authenticated either.

## Usage

The full endpoint reference is generated from the code and published at [adsb.mypreflight.io][docs-url].

A position report carries the fields a Mode S transponder would broadcast:

```shell
curl -X POST http://localhost/api/v1/position \
  -H 'Authorization: Bearer client-token' \
  -H 'Content-Type: application/json' \
  -d '{
    "callsign": "DLH1234",
    "date": "2025-08-08T15:46:38.250Z",
    "latitude": 51.47115,
    "longitude": -0.47351,
    "altitude": 91.95,
    "verticalRate": 0,
    "squawk": "6222",
    "groundSpeed": 0.32,
    "track": 179.07,
    "alert": false,
    "emergency": false,
    "spi": false,
    "isOnGround": true
  }'
```

Every field is required and the payload is validated on the way in: latitude and longitude have to be on the globe, and
`squawk` has to be four octal digits — `7700` is a valid emergency code, `7800` is not a code at all. Unknown
properties are rejected outright, so a malformed report gets a `400` instead of being silently trimmed.

Reports accumulate per callsign rather than overwriting, so `GET /api/v1/position/DLH1234` returns the whole track in
chronological order. An unknown callsign returns an empty array, not a `404`.

## Testing

To run tests, execute the following commands:

```bash
# unit tests
$ docker compose exec app npm run test

# functional tests
$ docker compose exec app npm run test:functional
```

We use **Jest** for unit tests, and **cucumber-js** for functional tests. Unit tests are stored in the `src` directory
just near the tested module, while functional tests are stored in the `features` directory.

## Build, test and deploy

This project uses [semantic versioning](https://semver.org/spec/v2.0.0.html).

Continuous integration and deployment run on GitHub Actions, configured in the `.github/workflows` directory. Every pull
request is audited, formatted, linted and tested; every merge to `main` tags the repository, cuts a release and pushes
the production image to `ghcr.io`.

## Contact

My name is Oskar, an experienced programmer, cybersecurity enthusiast, and conference speaker from Poland. Feel free to
contact me via the platforms below:

<div align="center">

[![LinkedIn][linkedin-badge]][linkedin-url]
[![GitHub][github-badge]][github-url]
[![Website][web-badge]][web-url]

</div>

## License

A public domain under the [Unlicense][license-url]. Do what you want with it. I am an experienced software engineer, but
I am not connected anyhow with the airline industry. This project is created for educational purposes only and should
not be used for real-world aviation operations.

[linkedin-badge]: https://img.shields.io/badge/Oskar%20Barcz-0A66C2?style=for-the-badge&logo=data%3Aimage%2Fsvg%2Bxml%3Bbase64%2CPHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHZpZXdCb3g9IjAgMCAyNCAyNCIgZmlsbD0iI2ZmZiI%2BPHBhdGggZD0iTTIwLjQ1IDIwLjQ1aC0zLjU1di01LjU3YzAtMS4zMy0uMDMtMy4wNC0xLjg1LTMuMDQtMS44NSAwLTIuMTQgMS40NS0yLjE0IDIuOTR2NS42N0g5LjM1VjloMy40MXYxLjU2aC4wNWMuNDgtLjkgMS42NC0xLjg1IDMuMzctMS44NSAzLjYgMCA0LjI3IDIuMzcgNC4yNyA1LjQ2djYuMjl6TTUuMzQgNy40M2MtMS4xNCAwLTIuMDYtLjkzLTIuMDYtMi4wNiAwLTEuMTQuOTItMi4wNiAyLjA2LTIuMDYgMS4xNCAwIDIuMDYuOTMgMi4wNiAyLjA2IDAgMS4xNC0uOTMgMi4wNi0yLjA2IDIuMDZ6bTEuNzggMTMuMDJIMy41NlY5aDMuNTZ2MTEuNDV6TTIyLjIzIDBIMS43N0MuNzkgMCAwIC43NyAwIDEuNzN2MjAuNTRDMCAyMy4yMy43OSAyNCAxLjc3IDI0aDIwLjQ1QzIzLjIgMjQgMjQgMjMuMjMgMjQgMjIuMjdWMS43M0MyNCAuNzcgMjMuMiAwIDIyLjIzIDB6Ii8%2BPC9zdmc%2B&logoColor=white
[linkedin-url]: https://www.linkedin.com/in/oskarbarcz
[github-badge]: https://img.shields.io/badge/@oskarbarcz-181717?style=for-the-badge&logo=github&logoColor=white
[github-url]: https://github.com/oskarbarcz
[web-badge]: https://img.shields.io/badge/barcz.me-4A5568?style=for-the-badge&logo=googlechrome&logoColor=white
[web-url]: https://barcz.me
[banner]: .github/image/banner.png
[homepage]: https://mypreflight.io
[transponder-repo]: https://github.com/mypreflight/transponder-app
[docs-url]: https://adsb.mypreflight.io/api
[ci-badge]: https://img.shields.io/github/actions/workflow/status/mypreflight/adsb-receiver-api/integrity.yaml?branch=main&style=for-the-badge&label=integrity
[ci-url]: https://github.com/mypreflight/adsb-receiver-api/actions/workflows/integrity.yaml
[release-badge]: https://img.shields.io/github/v/release/mypreflight/adsb-receiver-api?style=for-the-badge
[release-url]: https://github.com/mypreflight/adsb-receiver-api/releases/latest
[license-badge]: https://img.shields.io/github/license/mypreflight/adsb-receiver-api?style=for-the-badge
[license-url]: https://unlicense.org
[node-shield]: https://img.shields.io/badge/Node.js-339933?style=for-the-badge&logo=nodedotjs&logoColor=white
[node-url]: https://nodejs.org
[ts-badge]: https://img.shields.io/badge/TypeScript-3178C6?style=for-the-badge&logo=typescript&logoColor=white
[ts-url]: https://www.typescriptlang.org
[nest-badge]: https://img.shields.io/badge/NestJS-E0234E?style=for-the-badge&logo=nestjs&logoColor=white
[nest-url]: https://nestjs.com
[docker-badge]: https://img.shields.io/badge/Docker-2496ED?style=for-the-badge&logo=docker&logoColor=white
[docker-url]: https://www.docker.com
