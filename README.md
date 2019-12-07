# 📖 BetterReads API

This is the API for ***BetterReads*** (to be renamed, presumably 🙂). It is written in Swift based on the [Vapor] framework.

## Developer Setup

It is recommended, though not strictly required, to install [Vapor Toolbox]. With the Toolbox installed, you can generate an Xcode project with:

```
vapor xcode
```

You can then build and run through Xcode.

You can also build and run through Vapor with:

```
vapor build
vapor run
```

The API requires a running Postgres database. For your convenience, there is a development `docker-compose.yml` that launches the API and Postgres and connects them. You can build and run with:

```
docker-compose up --build -d
```

When running with Xcode, you can also run Postgres on your own; development builds expect it to be running on `127.0.0.1:5432` with a user named `postgres`.
