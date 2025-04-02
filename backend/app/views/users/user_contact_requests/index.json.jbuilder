json.user_contact_requests @user_contact_requests do |user_contact_request|
  json.created_at user_contact_request.created_at
  json.updated_at user_contact_request.updated_at
  json.user_uuid user_contact_request.user.uuid
  json.contacted_uuid user_contact_request.contacted.uuid
end