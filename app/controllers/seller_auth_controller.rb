# SAML authentication for sellers
class SellerAuthController < ApplicationController
  skip_before_action :authenticate_admin
  skip_before_action :verify_authenticity_token, only: [:consume, :logout]

  layout 'login'

  def login
    reset_session_keys

    return stub_auth if APP_CONFIG['stub_auth']

    request = OneLogin::RubySaml::Authrequest.new
    redirect_to request.create(saml_settings)
  end

  def consume
    response = OneLogin::RubySaml::Response.new(params[:SAMLResponse], settings: saml_settings)

    unless response.is_valid?
      logger.error "[SAML_AUTH] Response Invalid. Errors: #{response.errors}."
      redirect_to(root_path, alert: 'Inloggning misslyckades') && return
    end

    seller = update_seller(response.attributes['Subject_SerialNumber'], response.attributes['Subject_CommonName'])

    unless seller
      logger.warn '[SAML_AUTH] User not registered in the system.'
      redirect_to(root_path, alert: 'Du är inte registrerad i systemet') && return
    end

    # Establish session and redirect to the page requested by user
    session[:seller_id] = seller.id
    update_session
    redirect_after_login && return

  rescue => e
    logger.fatal "[SAML_AUTH] SAML response failed. #{e.message}"
    redirect_to root_path, alert: 'Inloggningen misslyckades'
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

  def update_seller(snin, name)
    snin = Snin.new(snin)

    seller = Seller.where_snin(snin.long).first
    return false unless seller

    seller.name = name
    seller.last_login_at = Time.now
    seller.save
    seller
  end

  def base_url
    "#{request.protocol}#{request.host}"
  end

  def saml_settings
    config = Rails.application.secrets.saml

    # Metadata URI settings
    # Returns OneLogin::RubySaml::Settings prepopulated with idp metadata
    # idp_metadata_parser = OneLogin::RubySaml::IdpMetadataParser.new
    # settings = idp_metadata_parser.parse_remote config[:idp_metadata]

    settings = OneLogin::RubySaml::Settings.new
    settings.issuer                         = base_url
    settings.idp_sso_target_url             = config[:idp_sso_target_url]
    settings.assertion_consumer_service_url = "#{base_url}/saml/consume"

    # Non-metadata URI settings
    # settings.idp_cert                       = config[:idp_cert]
    settings.idp_cert_fingerprint           = config[:idp_cert_fingerprint]
    settings.idp_cert_fingerprint_algorithm = 'http://www.w3.org/2000/09/xmldsig#sha1'
    settings.name_identifier_format         = 'urn:oasis:names:tc:SAML:2.0:nameid-format:transient'
    settings.authn_context                  = "urn:oasis:names:tc:SAML:2.0:ac:classes:#{config[:idp_authn_context]}"
    settings.compress_request               = false

    # setting.security (signing) is documented at https://github.com/onelogin/ruby-saml#signing

    settings
  end

  # Stubbed auth for local dev env
  # A user with the role seller has to exist first
  def stub_auth
    # reset_session_keys

    unless Rails.application.config.consider_all_requests_local
      redirect_to root_path, alert: 'Stubbed authentication only available in local environment'
    end

    seller = Seller.first
    if seller
      session[:seller_id] = seller.id
      update_session
      redirect_after_login && return
    end

    redirect_to root_path, alert: 'Create a user with role `seller` first'
  end
end
