module Cybermut
  class Confirmation
    attr_accessor :params
    attr_accessor :raw
    
    
    cattr_accessor :action_url
    @@action_url = 'https://ssl.paiement.cic-banques.fr/test/paiement.cgi'

    cattr_accessor :hmac_sha1_key
    @@hmac_sha1_key = 'd85b0f33061bf2a0f9600475a631c821cd39731a'

    cattr_accessor :hmac_sha1_pass
    @@hmac_sha1_pass = 'ECHDOk9HqiT3uYYUSF-m'

  
    def initialize(post)
      empty!
      @result  = 'None'
      @receipt = "Document Falsifie"
      parse(post)
    end
  
    def parse(post)
       @raw = post
       for line in post.split('&')
        key, value = *line.scan( %r{^(.+)\=(.*)$} ).flatten
#        puts "#{key} : #{CGI.unescape(value)}"

        if key
          params[key] = CGI.unescape(value)
        end
       end
     end
    
     def empty!
       @params  = Hash.new
       @raw     = ""
     end
        
    def tpe
      params['TPE']
    end
    
    def date
      params['date']
    end
    
    def montant
      params['montant']
    end
    
    def montant_euros
      self.montant.gsub(/EUR/,"").to_f
    end
    
    def reference
      params['reference']
    end
    
    def mac
      params['MAC']
    end
    
    def texte_libre
      params['texte-libre']
    end
    
    def code_retour
      params['code-retour']
    end
    
    def retour_plus
      params['retourPLUS']
    end
    
    def acknowledge
        @mac = params["MAC"]
 
        @data  = "#{retour_plus}"

        @data += "#{tpe}+"
        @data += "#{date}+"
        @data += "#{montant}+"

        @data += "#{reference}+"
        @data += "#{texte_libre}+"
        @data += "1.2open+"

        @data += "#{code_retour}+"

      
        # must be code_retour=="paiement"
        # code_retour!="Annulation" and 
        if @mac.downcase == Cybermut::Helpers.hmac(@data)
          @result = code_retour + retour_plus
          @receipt = "OK"
          return true
        else
          @result  = 'None'
          @receipt = "Document Falsifie"
          return false
        end
    end
    
    def response
      "Pragma: no-cache\nContent-type : text/plain\nVersion:1\n#{@receipt}"
      # "\n#{Time.now.strftime("%d/%m/%Y:%H:%M:%S")}"      
    end
  
  
    
  
  end
end