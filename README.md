# Respriter

Generate sprites on demand

## How it works

Respriter is a simple service that expects SVG sprite URLs (possibly versioned) as inputs
and outputs on demand a subset of the original sprites as a final reduced sprite using the following API endpoint:

`/:version?sprite_a=x,y&sprite_b=w,z`

The above means: Get me `<symbols>` x and y from sprite_a and `<symbols>` w and z from sprite_b
and return me as another SVG sprite. All `<defs>` that those specific `<symbols>` depend on are
also present in the final SVG sprite.

## Setup

run `make setup`

## infrastructure

run `cd terraform && terraform init && terraform plan`

## image

run `cd packer && packer build ubuntu.json`

## deploy

- Just push to either production or staging branch
- appspec.yml controls [deployment](https://docs.aws.amazon.com/codedeploy/latest/userguide/reference-appspec-file-structure-hooks.html#reference-appspec-file-structure-hooks-list)
