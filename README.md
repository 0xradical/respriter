# Respriter

Generate sprites on demand

## setup

run `make setup`

## infrastructure

run `cd terraform && terraform init && terraform plan`

## image

run `cd packer && packer build ubuntu.json`

## deploy

- Just push to either production or staging branch
- appspec.yml controls [deployment](https://docs.aws.amazon.com/codedeploy/latest/userguide/reference-appspec-file-structure-hooks.html#reference-appspec-file-structure-hooks-list)
