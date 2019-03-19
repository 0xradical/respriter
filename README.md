<img src='https://quero.com/assets/quero-logo.svg' width='220px'/> 

![website status](https://shields.quero.com/website/https/quero.com.svg)
![GitHub pull requests](http://shields.quero.com/github/issues-pr/querocourses/web-app.svg)

## Setting up your environment

### Requirements

* Docker & Docker Compose

### Setup your environment

__1__ - Run

```bash
  make bootstrap
```

__2__ - Run the server

```bash
  make rails
```

## Helpers

To access the container tty

```bash
  ./console
```

### Pending Tasks

- [ ] Change all AWS & third-party keys commited on .env.example file | Remove keys
- [ ] Create github -> ci -> heroku workflow
- [ ] Mock OAuths
- [ ] Move helpers to a Makefile ?
- [ ] Add S3 as a service on docker-compose
- [ ] Create a proxy server for services that don't have a sandbox environment (affiliators)
- [ ] Update README.md with an architecture diagram and how it relates to other sub-systems (elements and blocks)

## Running tests

### Cucumber

To run integration tests, just call cucumber

```bash
  ./cucumber
```

As `./cucumber` is just acting as a proxy, you can pass any cli arguments you will

```bash
./cucumber --tags @guest-signs-up-2
```

If you want to debug your running tests, open Chrome and type `http://localhost:9222`
