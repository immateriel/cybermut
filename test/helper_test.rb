require 'test/unit'
require 'cybermut'

require 'action_controller'
require 'action_controller/test_process'
require 'html/document'

class TestController < ActionController::Base
  include Cybermut::Helpers
  include ActionView::Helpers::TagHelper
  include ActionView::Helpers::FormHelper
  include ActionView::Helpers::UrlHelper
  include ActionView::Helpers::FormTagHelper
end

class HelperTest < Test::Unit::TestCase

  def assert_inputs(options, text)
     all = text.scan(/name\=\"(\w+)\"/).flatten

     xor = (options.keys | all) - (options.keys & all)

     # xor
     assert_equal [], xor, "options do not match expectations does not have keys #{xor.inspect} only appear in one of both sides in \n\n#{text}"

     text.scan(/name\=\"([^"]+).*?value\=\"([^"]+)/) do |key, value|
       if options.has_key?(key)
         assert_equal options[key], value, "key #{key} was '#{options[key]}' and not '#{value}' in \n\n#{text}"
       end
     end
   end


  def setup
      @helpers = TestController.new
    end

    def test_cybermut_form_start
      assert_equal %{<form action="https://ssl.paiement.cic-banques.fr/test/paiement.cgi" method="post">}, @helpers.cybermut_form_tag
    end
    
    def test_cybermut_setup
        actual = @helpers.cybermut_setup("100", 300.50, "0000001")
        date=Time.now.strftime("%d/%m/%Y:%H:%M:%S")
        assert_inputs({ "montant" => "300.5EUR",
                        "TPE" => "0000001",
                        "reference" => "100",
                        "lgue" => "FR",
                        "texte_libre"=>"",
                        "url_retour"=>"",
                        "url_retour_ok"=>"",
                        "url_retour_err"=>"",
                        "societe"=>"undefinedSiteCode",
                        "version"=>"1.2open",
                        "MAC"=>Cybermut::Helpers.hmac("0000001*"+date+"*300.5EUR*100**1.2open*FR*undefinedSiteCode*"),
                        "date"=>date
                        
                        }, actual)
      end
    


end
