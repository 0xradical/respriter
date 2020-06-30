# Respriter

Generate sprites on demand

## How it works

Respriter is a simple service that expects SVG sprite URLs (possibly versioned) as inputs
and outputs on a demand basis a subset of the original sprites as a final reduced sprite using the following API endpoint:

`/:version?sprite_a=x,y&sprite_b=w,z`

The above means: Get me `<symbols>` x and y from sprite_a and `<symbols>` w and z from sprite_b
from version `:version` and return me another SVG sprite with all thoses symbols. All `<defs>` that those specific `<symbols>` depend on are also present in the final SVG sprite.

## Setup

run `make setup`

## Infrastructure

The infrastructure for the respriter service is as follows:

![Respriter Topology on AWS](/docs/topology.svg)

run `cd terraform && terraform init && terraform plan`

## EC2 Image (AMIs)

[Packer](https://www.packer.io/) by Hashicorp™ is a tool to generate images for EC2, Docker, etc based on configuration files. To generate a specific AMI that will be used as base image in an EC2 machine for the respriter service, run:

`packer build packer/ubuntu.json`

P.S.: The above assumes you have `packer` installed on your host machine and
a `$HOME/.aws/credentials` file with a `[mfa]` section. This `[mfa]` section must
be populated with your AWS credentials (including the session token) using MFA.
Refer to [this documentation](https://aws.amazon.com/premiumsupport/knowledge-center/authenticate-mfa-cli/) to read more.

## Deploy

- Just push to either production or staging branch
- appspec.yml controls [deployment](https://docs.aws.amazon.com/codedeploy/latest/userguide/reference-appspec-file-structure-hooks.html#reference-appspec-file-structure-hooks-list)

## TODO

- We currently configure specific sprite families statically on the elements server file (processor.js)
