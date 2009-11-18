require 'openssl'
require 'net/http'
require 'test/unit'
require 'cybermut'

class ConfirmationTest < Test::Unit::TestCase

  def setup
    @cybermut = Cybermut::Confirmation.new(http_raw_data)
  end


  def test_parse
      @cybermut= Cybermut::Confirmation.new(http_raw_data)
      assert_equal "62.75EUR", @cybermut.params['montant']
      assert_equal "1234567", @cybermut.params['TPE']
      assert_equal "ABERTYP00145", @cybermut.params['reference']
      # ...
    end
    
    def test_accessors
      assert "62.75EUR", @cybermut.montant
      assert 62.75, @cybermut.montant_euros

      # ...
    end
    
    def test_acknowledge
      #puts http_raw_data
      @cybermut= Cybermut::Confirmation.new(http_raw_data)
      assert @cybermut.acknowledge
#      puts @cybermut.response
    end
    
    
    def http_raw_data
      "TPE=1234567&date=05%2f12%2f2006%5fa%5f11%3a55%3a23&montant=62%2e75EUR&reference=ABERTYP00145&MAC=11a2cd6548c2640ad0b0bb58b204addf34c4458c&texte-libre=reference+commande+tres+tres+longue&code-retour=paiement&retourPLUS=--optionA--optionB"
    end

  
end