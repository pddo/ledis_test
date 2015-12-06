require_relative './test_helper.rb'

class MyHTTP
  include HTTParty
  base_uri('162.243.174.242')
end

describe 'Ledis spec' do
  before(:all) do
    @http = MyHTTP
  end

  describe 'String spec' do
    before(:all) do
      @str_key1 = 'string_key1'
      @str_val1 = 'string_value1'
    end
    
    it 'should set & get a string' do
      command = "set #{@str_key1} #{@str_value}"
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
end
