json.array!(@supports) do |support|
  json.extract! support, :id, :sender_name, :email, :subject, :message
  json.url support_url(support, format: :json)
end
