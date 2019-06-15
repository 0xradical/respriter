module Rack
  class Prerender
    def build_rack_response_from_prerender(prerendered_response)
      response = if prerendered_response.code.to_i == 200
        Rack::Response.new(prerendered_response.body, 200, { 'Content-Type' => 'text/html; charset=utf-8' })
      else
        Rack::Response.new(prerendered_response.body, prerendered_response.code, prerendered_response.header)
      end

      @options[:build_rack_response_from_prerender].call(response, prerendered_response) if @options[:build_rack_response_from_prerender]

      response
    end
  end
end