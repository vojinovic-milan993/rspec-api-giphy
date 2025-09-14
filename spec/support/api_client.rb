require "httparty"
require "json"

class ApiClient
  include HTTParty

  def initialize(base_url: ENV.fetch("API_BASE_URL"), api_key: ENV["API_KEY"])
    @base_url = base_url
    @api_key  = api_key
    @headers  = { "Content-Type" => "application/json" }
  end

  def get(path, params: {}, **opts)
    query = params.merge(api_key: @api_key)
    url   = full_url(path)
    self.class.get(url, headers: @headers, query: query, **opts)
  end

  private

  def full_url(path)
    "#{@base_url}#{path}"
  end
end
