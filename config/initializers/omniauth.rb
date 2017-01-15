OmniAuth.config.logger = Rails.logger

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :google_oauth2, '445390176188-9sl1v5t7ifc3q0v5g67gkg3ia33co1i1.apps.googleusercontent.com', 'M4V2AXAannw1uw_AyE_tH5hF', {client_options: {ssl: {ca_file: Rails.root.join("cacert.pem").to_s}}}
end
