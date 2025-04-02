# UserContacts

## Introduction

The UserContacts resource allows you to manage contacts between users. You can create, list all contacts.

## Endpoints

### GET /users/user_contacts

This endpoint is used to retrieve a list of all contacts for the authenticated user.

#### Request

No request body.

#### Responses

##### 200 OK

```json
{
	"user_contacts": [
		{
			"created_at": "2025-04-02T05:36:56.350Z",
			"updated_at": "2025-04-02T05:36:56.350Z",
			"contacteds": [
				{
					"user_uuid": "8571452c-da71-4759-ad84-71da63e7b620"
				},
				{
					"user_uuid": "3745d666-a6ca-44b3-b3f3-4b28ea5737ae"
				}
			]
		},
		{
			"created_at": "2025-04-02T05:40:55.111Z",
			"updated_at": "2025-04-02T05:40:55.111Z",
			"contacteds": [
				{
					"user_uuid": "8571452c-da71-4759-ad84-71da63e7b620"
				},
				{
					"user_uuid": "3745d666-a6ca-44b3-b3f3-4b28ea5737ae"
				}
			]
		}
	]
}
```

##### 500 Internal Server Error

No response body.