# Infrastructure

This is the terraform configuration for the cloud service infrastructure needed for this project. It is designed so that multiple devs on your team can share the same AWS account without affecting each others' services.

## Environment Variables

You will need to create a file for env vars and fill in the values based on the instructions provided:

```sh
cp .env.example .env
```

And set them in the shell:

```sh
. .env
```

## Terraform Initialization

- download [tfenv](https://github.com/tfutils/tfenv) (like rbenv, nvm, etc. for tf). Do this before installing Terraform.
- `tfenv use`
- `terraform init`
- `terraform apply`

## Troubleshooting

If you can't delete a resource using terraform due to some error, for example an s3 bucket that won't allow deletion:

```sh
./bin/remove_resources_from_state.sh aws_s3
```

Then manually delete the resources using the aws UI
