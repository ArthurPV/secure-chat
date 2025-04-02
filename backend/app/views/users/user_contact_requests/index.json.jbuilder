json.(@user_contact_requests, :created_at, :updated_at) do |user_contact_request|
  json.user_uuid user_contact_request.user.uuid
  json.contacted_uuid user_contact_request.contacted.uuid
end