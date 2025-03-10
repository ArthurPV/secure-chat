# Registration

## Introduction

The registration endpoint is used to create a new user account.

## Endpoints

### POST /auth/sign_up

This endpoint is used to create a new user account.

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

#### Response

##### 200 OK

No response body.

##### 422 Unprocessable Content

No response body.