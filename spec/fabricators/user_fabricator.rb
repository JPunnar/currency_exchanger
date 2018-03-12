# frozen_string_literal: true

Fabricator(:user) do
  email { "info-#{rand(1000000)}@example.com" }
  password "testtest"
  username { "username#{rand(1000000)}" }
end
