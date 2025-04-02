json.(@user_contacts, :created_at, :updated_at) do |user_contact|
  json.contacteds user_contact.contacteds do |contacted|
    json.user_uuid contacted.user.uuid
  end
end