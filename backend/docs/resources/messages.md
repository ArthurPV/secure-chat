# Messages

## Introduction

The messages endpoint is used to manage lifecycle of messages.

## Endpoints

### POST /messages

This endpoint is used to create a new message.

| Attribute | Type   | Description |
| --------- | ------ | ----------- |
| content   | string | The content of the message |
| conversation_uuid | string | The UUID of the conversation where the message belongs |

#### Request

```json
{
  "message": {
    "content": "Hello, world!",
    "conversation_uuid": "f7b3b3b0-4b3b-4b3b-4b3b-4b3b3b3b3b3b"
  }
}
```

#### Response

##### 200 OK

No response body.

##### 422 Unprocessable Content

No response body.

### DELETE /messages/:uuid

This endpoint is used to delete a message.

#### Request

No request body.

#### Responses

##### 204 No Content

No response body.

##### 422 Unprocessable Content

No response body.
