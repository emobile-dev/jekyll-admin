module Jekyll
  module Admin
    class Server < Sinatra::Base
      ROUTES = %w(collections configuration data pages static_files).freeze

      configure :development do
        register Sinatra::Reloader
      end

      get "/" do
        json ROUTES.map { |route| ["#{route}_api", URI.join(base_url, "/_api/", route)] }.to_h
      end

      private

      def site
        Jekyll::Admin.site
      end

      def render_404
        status 404
        content_type :json
        halt
      end

      def request_payload
        @request_payload ||= begin
          request.body.rewind
          JSON.parse request.body.read
        end
      end

      def base_url
        "#{request.scheme}://#{request.host_with_port}"
      end
    end
  end
end