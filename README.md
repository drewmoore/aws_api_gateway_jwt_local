This is a development tool that allows for you to send requests through an AWS API Gateway to your locally running app. Authentication occurs using jwt openid auth, also running an openid server locally.

This assumes to be running in a subfolder of another project. The host project is assumed to use docker compose, and the name of your main app's service is assumed to be `my-app` (not a perfect drop-in for any project, I'll admit). Your app's main service and this add-on use an external network named `my_app`.

## Getting Started

Install ngrok and create free account. Store the api key in the `.env.ngrok` file:
```sh
cp .env.ngrok.example .env.ngrok
```

Follow the instructions for setting up your environment for terraform in [./infra](./infra/README.md)

To run the app and manage the infrastucture, run:

```sh
make
```

Then you can generate a jwt for authentication with the API Gateway:

```sh
make jwt
```
Use this in the header `Authorization: Bearer TOKEN`
Tip: you can use [jwt.io](https://jwt.io) to inspect tokens

To just run the app:

```sh
make app
```

Or if you just need to apply the infrastructure configuration:

```sh
make apply_infra
```

To teardown the local app but not the cloud infrastructure:

```sh
make teardown_app
```

To teardown the cloud infrastructure:

```sh
make teardown_infra
```
