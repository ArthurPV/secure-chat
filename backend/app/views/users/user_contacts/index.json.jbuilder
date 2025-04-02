json.user_contacts @user_contacts do |user_contact|
  json.created_at user_contact.created_at
  json.updated_at user_contact.updated_at
  json.contacteds user_contact.user_contacteds do |contacted|
    json.user_uuid contacted.user.uuid
  end
end
