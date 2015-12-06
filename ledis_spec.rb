require_relative './test_helper.rb'

class MyHTTP
  include HTTParty
  #base_uri('162.243.174.242')
  base_uri('localhost:8080')

  def self.exec(command, key = nil, *vals)
    cmd = build_command(command, key, vals)
    body = JSON.generate({command: cmd})
    options = { body: body
      # headers: {
      #   'content-type' => 'application/json',
      #   'Content-Length' => 10
      # }
    }
    post('/ledis', options)
  end

  def self.exec_with_result(command, key = nil, *vals)
    res = exec(command, key, vals)
    unless res.body.empty?
      result = JSON.parse(res.body)['response']
    else
      result = ''
    end
    
    [res, result]
  end

  def self.build_command(command, key = nil, *vals)
    cmd = command.to_s
    cmd +=  ' ' + key.to_s if key
    cmd += " " + vals.join(' ') if vals
    cmd
  end

  def self.clear
    exec('FLUSHDB')
  end

end

describe 'Ledis spec' do
  before(:all) do
    @http = MyHTTP
    @str_key1 = 'string_key1'
    @str_val1 = 'string_value1'
  end

  describe 'String spec' do
    before(:all) do
    end
    
    it 'should set & get a string' do
      res = @http.exec(:set, @str_key1, @str_val1)
      verify_good_response(res)

      verify_good_response(res)

      res, result = @http.exec_with_result(:set, @str_key1, @str_val1)
      
      verify_good_response(res)
      result.must_equal 'OK'
    end
  end

  describe 'General' do
     before(:all) do
     end
     
    it 'should clear all keys' do
      res, result = @http.exec_with_result(:set, @str_key1, @str_val1)
      verify_good_response(res)
      result.must_equal 'OK'

      res, result = @http.exec_with_result(:set, @str_key1, @str_val1)
      verify_good_response(res)

      result.must_equal 'OK'
      
      @http.clear

      res, result = @http.exec_with_result(:get, @str_key1, @str_val1)
      verify_good_response(res)

      result.must_equal 'EKTYP'
    end
  end

  def verify_good_response(res)
    puts res.code,
      res.message,
      res.headers.inspect,
      res.body

    res.code.must_equal 200
    res.message.must_equal 'OK'
  end
end
