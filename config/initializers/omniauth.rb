Rails.application.config.middleware.use OmniAuth::Builder do
  provider :google_oauth2, '189730274010-cui99so9t9bsre6unhlpgkv82t1o0psc.apps.googleusercontent.com', 'pK374RYzOa2xNcxQBX3cRhU6',
  {scope: ['email', 'https://www.googleapis.com/auth/gmail.modify'], access_type: 'offline'}
end
