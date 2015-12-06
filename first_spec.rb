require_relative './test_helper.rb'

class MyHTTP
  include HTTParty
  base_uri('162.243.174.242')
end

describe 'first try' do
  before(:all) do
    @http = MyHTTP
  end

  it 'should work' do
    params = {input: '1+2+3;', authentication: '1571168050', engine: '1'}
    res = @http.post('/api/v1/solutions/create', query: params)
    puts res.code,
      res.message,
      res.headers.inspect,
      res.body

    body = JSON.parse(res.body)
    puts 
    body['count'].must_equal 1
  end
end
