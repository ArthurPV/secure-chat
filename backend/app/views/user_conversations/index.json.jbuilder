json.conversations @conversations do |conversation|
  json.partial! "user_conversations/user_conversation", user_conversation: conversation
  json.messages conversation.messages, partial: "user_conversations/message", as: :message
end
