# Authorization

## Introduction

This resource is used to obtain or revoke a JWT token that can be used to authenticate requests to the API.

## Endpoints

### POST /auth/sign_in

This endpoint is used to obtain a JWT token. The token is valid for 2 weeks.

> [!NOTE]
> You don't need to give any JWT token to access this endpoint.

| Attribute | Type   | Description |
| --------- | ------ | ----------- |
| email     | string | The email of the user |
| password  | string | The password of the user |

#### Request

```json
{
  "user": {
    "email": "user@localdev.me",
    "password": "password"
  }
}
```

#### Responses

##### 200 OK

```json
{
  "token": "eyJhbGciOiJIUzI1NiJ9.eyJqdGkiOiJhZTY5NGM2Mi05MGY1LTQ4MjctYWQxMi04ZDI4MjIxODJiNTQiLCJleHAiOjE3NDI0Nzk1NTQsImF1ZCI6InNlY3VyZS1jaGF0In0.QzZ4chg6rroVFPnwgwghYBdrPqQRmLUmoQPzxrKdqX4"
}
```

##### 401 Unauthorized

No response body.

### DELETE /auth/sign_out

This endpoint is used to revoke a JWT token.

#### Request

No request body.

#### Responses

##### 204 No Content

No response body.

##### 401 Unauthorized

No response body.