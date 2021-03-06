module GoogleClient
  # Exception to handle a missing initializer
  # class MissingConfiguration < StandardError
  #   def initialize
  #     super('Configuration for authinator missing. Do you have an Authinator initializer?')
  #   end
  # end

  # Module level methods
  class << self
    attr_accessor :configuration
  end

  def self.configure
    self.configuration ||= Configuration.new
    yield(configuration)
  end

  def self.client
    configuration.client
  end

  def self.authorization
    configuration.authorization
  end

  # def self.configuration
  #   @config || (fail MissingConfiguration.new)
  # end

  # Configuration class
  class Configuration
    attr_accessor :client_id,
                  :client_secret,
                  :redirect_uris,
                  :javascript_origins,
                  :auth_uri,
                  :token_uri,
                  :app_name,
                  :app_version

    def initialize
      @redirect_uris = []
      @javascript_origins = []
      @auth_uri = 'https://accounts.google.com/o/oauth2/auth'
      @token_uri = 'https://accounts.google.com/o/oauth2/token'
    end

    def client
      return @client if @client
      errors = []

      # symbols = %i(app_name app_version)
      # symbols.each do |sym|
      #   errors << errors_for(sym)
      # end
      errors << 'app_name not set' unless @app_name.present?
      errors << 'app_version not set' unless @app_version.present?

      fail "Couldn't create the client:\n" << errors.to_sentence unless errors.blank?

      @client = Google::APIClient.new(application_name: @app_name,
                                      application_version: @app_version)
    end

    def authorization
      errors = []

      errors << 'app_name not set' unless @app_name.present?
      errors << 'app_version not set' unless @app_version.present?

      fail "Couldn't create the authorizationt:\n" << errors.to_sentence unless errors.blank?
      Google::APIClient::ClientSecrets.new(to_hash).to_authorization
    end

    def to_hash
      { web: {
        client_id: @client_id,
        client_secret: @client_secret,
        redirect_uris: @redirect_uris,
        javascript_origins: @javascript_origins,
        auth_uri: @auth_uri,
        token_uri: @token_uri,
      } }.with_indifferent_access
    end

  private

    # def errors_for(sym)
    #   send(sym)
    # rescue NoMethodError
    #   "#{sym} not set"
    # end
  end
end
