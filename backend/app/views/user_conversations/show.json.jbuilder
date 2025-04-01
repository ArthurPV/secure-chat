json.partial! "user_conversations/user_conversation", user_conversation: @entity
json.messages @entity.messages, partial: "user_conversations/message", as: :message
