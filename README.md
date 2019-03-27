<img src='https://quero.com/assets/quero-logo.svg' width='220px'/> 

![website status](https://shields.quero.com/website/https/quero.com.svg)
![GitHub pull requests](http://shields.quero.com/github/issues-pr/querocourses/web-app.svg)

## Setting up your environment

### Requirements

* Docker & Docker Compose

### Setup your environment

__1__ - Build your application

```bash
  make bootstrap
```

__2__ - Run the server

```bash
  make rails
```

_3_ - Ask for help

```bash
  make
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

To run the complete test suite (e2e and unit tests)

```bash
  make tests
```

To run e2e tests run

```bash
  make cucumber
```

If you want to debug your running tests, open Chrome and type `http://localhost:9222`

## System Architecture
- [Elements - A component-based CSS framework](http:/github.com/querocourses/elements)
- [Blocks - A reactive component library](http:/github.com/querocourses/blocks)

<img src='system.svg'/>
