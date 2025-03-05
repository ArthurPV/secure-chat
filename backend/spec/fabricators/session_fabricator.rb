# frozen_string_literal: true

Fabricator(:session) do
  user { Fabricate.build(:user) }
  session_id { sequence(:session_id) { |i| "session_id_#{i}" } }
end
