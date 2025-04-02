# Rest API

## Introduction

The API is secured using JWT tokens. You can obtain a token by logging in to the system.

## Authentication

For most of endpoints, you need to provide the JWT token in the `Authorization` header. The token should be prefixed with `Bearer`.

If you don't provide a valid token (when it needed), you will receive a `401 Unauthorized` response.

## Resources

Here is a list of resources that are available in the API:

- [auth/Authorization](resources/auth/authorization.md)
- [auth/Registration](resources/auth/registration.md)
- [users/UploadProfilePictures](resources/users/upload_profile_pictures.md)
- [users/UserContactRequests](resources/users/user_contact_requests.md)
- [users/UserContacts](resources/users/user_contacts.md)
- [Messages](resources/messages.md)
- [UserConversations](resources/user_conversations.md)
