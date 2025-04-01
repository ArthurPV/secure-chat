# UserConversations

## Introduction

The user_conversations endpoint is used to manage lifecycle of user conversations.

## Endpoints

### POST /user_conversations

This endpoint is used to create a new user conversation.

| Attribute | Type   | Description |
| --------- | ------ | ----------- |
| public_key | string | The public key of the conversation, used to encrypt messages |
| private_key | string | The private key of the conversation, used to decrypt messages |
| participants | array of string (uuid) | The list of participants in the conversation (UUID) |

#### Request

```json
{
  "user_conversation": {
    "public_key": "public_key",
    "private_key": "private_key",
    "participants": ["f7b3b3b0-4b3b-4b3b-4b3b-4b3b3b3b3b3b"]
  }
}
```

#### Response

##### 200 OK

No response body.

##### 422 Unprocessable Content

No response body.

### DELETE /user_conversations/:uuid

This endpoint is used to delete a user conversation.

#### Request

No request body.

#### Response

##### 204 No Content

No response body.

##### 422 Unprocessable Content

No response body.
