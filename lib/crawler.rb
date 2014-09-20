class Crawler
  def self.perform
    url = 'http://ww2.mobilicidade.com.br/bikesampa/mapaestacao.asp'
    response = HTTParty.get(url)

    Parser::Sampa.parse(response)
  end
end




