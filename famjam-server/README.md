## Endpoints

### `POST /api/users`

Register a new user.

Request

```
{
  "username": "roger",
  "password": "pasword"
}
```

### `POST /api/authenticate`

Authenticate a user and retrieve a token.

Request

```
{
  "username": "roger",
  "password": "password"
}
```

### `GET /api/topics` (_Secured_)

Retrieve a list of topics that corresponds to the user specified via Authorization header.

### `POST /api/topics` (_Secured_)

Create a new topic, and shares it to the specified users.

Request

```
{
  "name": "Lunch",
  "users": [
    "571c02e95aeb5ff9b4bd6e4a"
  ]
}
```

### `GET /api/topics/:id` (_Secured_)

Retrieve a topic and any data associated with it (images)

### `POST /api/topics/:id` (_Secured_)

Adds an image to the specified topic. Note that the image upload process takes place via the signed upload
endpoint as described below.

Request

```
{
  "description": "The bacon bowl here is amazing",
  "url": "https://s3-us-west-2.amazonaws.com/famjam/d046b419-cc72-4a2b-93b7-a5898efc1a85"
}
```

### `POST /api/get_signed_upload` (_Secured_)

Fetches a pre-signed endpoint for direct upload to S3.

Request

```
x-azm-acl: public-read
{
  "file-type": "image/jpeg"
}
```
