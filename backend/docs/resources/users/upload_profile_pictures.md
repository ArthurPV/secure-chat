# UploadProfilePictures

## Introduction

The upload_profile_pictures endpoint is used to upload profile pictures for users.

### PUT /users/upload_profile_pictures

This endpoint is used to upload profile pictures for users.

| Attribute | Type   | Description |
| --------- | ------ | ----------- |
| profile_picture | file | The profile picture of the user |

### Headers

| Key | Value |
| --- | ----- |
| Content-Type | multipart/form-data |

#### Request

```
user[profile_picture]=@path_of_file
```

#### Responses

##### 204 No Content

No response body.

##### 422 Unprocessable Content

No response body.

### DELETE /users/upload_profile_pictures

This endpoint is used to delete profile pictures for users.

#### Request

No request body.

#### Responses

##### 204 No Content

No response body.

##### 422 Unprocessable Content

No response body.
