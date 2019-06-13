describe 'PreRender Middleware', type: :request do
  let(:human) { 'Mozilla/5.0 (Macintosh; Intel Mac OS X x.y; rv:42.0) Gecko/20100101 Firefox/42.0' }
  let(:bot)   { 'Mozilla/5.0 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)'         }

  describe "GET /" do
    context 'when server is up' do
      before do
        stub_request(
          :get, Regexp.new("#{ENV['PRERENDER_SERVICE_URL']}")
        ).to_return(body: "A cached version of the home page")
      end

      context 'when user is a bot' do
        it 'returns a prerendered version of home page' do
          get "/", params: {}, headers: { 'HTTP_USER_AGENT' => bot }
          expect(response.status).to eq(200)
          expect(response.body).to eq("A cached version of the home page")
        end
      end

      context 'when user is not a bot' do
        it 'returns a non-prerendered version of home page' do
          get "/", params: {}, headers: { 'HTTP_USER_AGENT' => human }
          expect(response.status).to eq(200)
          expect(response.body).to_not eq("A cached version of the home page")
          expect(response.body).to match(/\<html\>/)
        end
      end
    end

    context 'when server is down' do
      before do
        stub_request(
          :get, Regexp.new("#{ENV['PRERENDER_SERVICE_URL']}")
        ).to_timeout
      end

      context 'when user is a bot' do
        it 'returns a non-prerendered version of home page' do
          get "/", params: {}, headers: { 'HTTP_USER_AGENT' => bot }
          expect(response.status).to eq(200)
          expect(response.body).to match(/\<html\>/)
        end
      end

      context 'when user is not a bot' do
        it 'returns a non-prerendered version of home page' do
          get "/", params: {}, headers: { 'HTTP_USER_AGENT' => human }
          expect(response.status).to eq(200)
          expect(response.body).to match(/\<html\>/)
        end
      end
    end

    context 'when server is bonkers' do
      before do
        stub_request(
          :get, Regexp.new("#{ENV['PRERENDER_SERVICE_URL']}")
        ).to_return(status: [500, "Internal Server Error"])
      end

      context 'when user is a bot' do
        it 'returns bonkered up result :(' do
          get "/", params: {}, headers: { 'HTTP_USER_AGENT' => bot }
          expect(response.status).to eq(500)
        end
      end

      context 'when user is not a bot' do
        it 'returns a non-prerendered version of home page' do
          get "/", params: {}, headers: { 'HTTP_USER_AGENT' => human }
          expect(response.status).to eq(200)
          expect(response.body).to match(/\<html\>/)
        end
      end
    end
  end
end
