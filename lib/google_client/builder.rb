module GoogleClient
  class Builder
    require 'oauth2/access_token'
    # require 'signet/errors'

    attr_reader :service

    def initialize(api, version, retries = 0)
      @client = GoogleClient.client
      @auth = GoogleClient.authorization.dup
      @service = @client.discovered_api(api, version) #
      @client.retries = retries
    end

    def execute(credential, method, parameters = {})
      preflight(credential)
      @client.execute(
          authorization: @auth,
          api_method: method,
          parameters: parameters,
      )
    end

    def execute_batch(credential, batch)
      preflight(credential)
      # @auth.update_token!(credential)
      @client.execute(batch, authorization: @auth)
    end

  private

    def preflight(credential)
      if credential.is_a?(OAuth2::AccessToken)
        hash = {
          access_token: credential.token,
          refresh_token: credential.refresh_token,
          expires_in: credential.expires_in,
          expires: credential.expires_in,
        }
        @auth.update_token!(hash) #
      else
        @auth.update_token!(credential.to_auth_hash) #
        return unless credential.expires_at < 5.minutes.from_now # Update the access token if it has potentially expired
        fetch_and_update_access_token!(credential)
      end
    end

    def fetch_and_update_access_token!(credential)
      @auth.fetch_access_token!
      credential.update_access_token!(
              token: @auth.access_token,
              expires_at: (Time.now.utc + @auth.expires_in),
      )
    rescue Signet::AuthorizationError => _e
      # If a refresh token is invalid for some reason we'll end up here.
      # This can also happen if *our* client token/secret is bad, so that needs to be dealt with too

      # Todo
      # if it's because the refresh token is bad, get the user to log out and in again.
      puts 'Auth attempt failed (either client ID/Secret are missing or user has a bad refresh token)'
      raise
    end
  end
end
