class Crawler
  def self.perform
    url = 'http://ww2.mobilicidade.com.br/bikesampa/mapaestacao.asp'
    response = HTTParty.get(url)

    encode_options = { :undef => :replace, :invalid=>:replace, :replace=>"?" }
    response = response.encode("iso-8859-1", encode_options).encode('UTF-8')

    Parser::Sampa.parse(response)
  end
end




