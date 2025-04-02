# UserContactRequests

## Introduction

The UserContactRequests resource allows you to manage contact requests between users. You can create, delete contact requests, as well as retrieve a list of all contact requests for a specific user.

### POST /users/user_contact_requests

This endpoint is used to create a new contact request.

| Attribute | Type   | Description |
| --------- | ------ | ----------- |
| contacted_uuid | string | The UUID of the user who is being contacted |

#### Request

```json
"user_contact_request": {
  "contacted_uuid": "string"
}
```

#### Responses

##### 204 No Content

No response body.

##### 422 Unprocessable Content

No response body.

### DELETE /users/user_contact_requests/uuid

This endpoint is used to delete a contact request.

#### Request

No request body.

#### Responses

##### 204 No Content

No response body.

##### 500 Internal Server Error

No response body.

### GET /users/user_contact_requests

This endpoint is used to retrieve a list of all contact requests for the authenticated user.

#### Request

No request body.

#### Responses

##### 200 OK

```json
{
	"user_contact_requests": [
		{
			"created_at": "2025-04-02T05:57:00.085Z",
			"updated_at": "2025-04-02T05:57:00.085Z",
			"user_uuid": "8571452c-da71-4759-ad84-71da63e7b620",
			"contacted_uuid": "3745d666-a6ca-44b3-b3f3-4b28ea5737ae"
		}
	]
}
```

##### 500 Internal Server Error

No response body.