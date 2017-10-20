class SamlController < ApplicationController
  skip_authorize_resource
  skip_authorization_check
  skip_before_action :authenticate
  skip_before_action :verify_authenticity_token, only: [:consume, :logout]

  layout 'login'

  def login
    return stub_auth if APP_CONFIG['stub_auth']

    request = OneLogin::RubySaml::Authrequest.new
    redirect_to request.create(saml_settings)
  end

  def consume
    response = OneLogin::RubySaml::Response.new(params[:SAMLResponse], settings: saml_settings)

    if response.is_valid?
      update_or_create_account(response.name_id)

      # Establish session and redirect to the page requested by user
      session[:user_id] = user.id
      update_session
      redirect_after_login && return
    end

    logger.error "[SAML_AUTH] Response Invalid. Errors: #{response.errors}."
    redirect_to root_path, notice: 'Inloggning misslyckades'
  rescue => e
    logger.fatal "[SAML_AUTH] SAML response failed. #{e.message}"
    redirect_to root_path, warning: 'Inloggningen misslyckades'
  end

  def metadata
    meta = OneLogin::RubySaml::Metadata.new
    render xml: meta.generate(saml_settings, true)
  end

  def logout
    reset_session_keys
    redirect_to Rails.application.secrets.saml[:idp_slo_target_url]
  end

  private

  def update_or_create_account(username)
    username = username.strip.downcase
    # Find or create user
    user                = User.where(role: 'seller', username: username).first_or_initialize
    user.username       = username
    user.last_login     = Time.now
    user.seller_account = SellerAccount.new(
      # key = value
    )
    user.save!
    user
  end

  def base_url
    "#{request.protocol}#{request.host}"
  end

  def saml_settings
    config = Rails.application.secrets.saml

    # Metadata URI settings
    # Returns OneLogin::RubySaml::Settings prepopulated with idp metadata
    # idp_metadata_parser = OneLogin::RubySaml::IdpMetadataParser.new
    # settings = idp_metadata_parser.parse_remote config['idp_metadata']

    settings = OneLogin::RubySaml::Settings.new
    settings.issuer                         = base_url
    settings.idp_sso_target_url             = config[:idp_sso_target_url]
    settings.assertion_consumer_service_url = "#{base_url}/saml/consume"

    # Non-metadata URI settings
    # settings.idp_cert                       = config['idp_cert']
    settings.idp_cert_fingerprint           = config[:idp_cert_fingerprint]
    settings.idp_cert_fingerprint_algorithm = 'http://www.w3.org/2000/09/xmldsig#sha1'
    settings.name_identifier_format         = 'urn:oasis:names:tc:SAML:1.1:nameid-format:emailAddress'
    settings.authn_context                  = 'urn:oasis:names:tc:SAML:2.0:ac:classes:MobileTwoFactorUnregistered'
    settings.compress_request               = false

    # setting.security (signing) is documented at https://github.com/onelogin/ruby-saml#signing

    settings
  end

  # Stubbed auth for local dev env
  # A user with the role seller has to exist first
  def stub_auth
    reset_session_keys

    unless Rails.application.config.consider_all_requests_local
      redirect_to root_path, warning: 'Stubbed authentication only available in local environment'
    end

    user = User.where(role: 'seller').first
    if user
      session[:user_id] = user.id
      redirect_after_login && return
    end

    redirect_to root_path, warning: 'Create a user with role `seller` first'
  end
end
