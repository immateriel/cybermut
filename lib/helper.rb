require 'digest/sha1'
require 'openssl'

module Cybermut
  module Helpers
 
    def cybermut_form_tag(url = Cybermut::Confirmation.action_url, options = {})
         form_tag(url, options)
    end
 
 
    def cybermut_setup(reference,montant,tpe, options={})
        misses = (options.keys - valid_cybermut_setup_options)
        raise ArgumentError, "Unknown option #{misses.inspect}" if not misses.empty?

        key=Cybermut::Confirmation.hmac_sha1_key
        pass=Cybermut::Confirmation.hmac_sha1_pass

        if options['key']
          key=options['key']
        end

        if options['pass']
          pass=options['pass']
        end

        params={}
        params['texte_libre'] = ""
        params['lgue'] = "FR"
        params['url_retour'] = ""
        params['url_retour_ok'] = ""
        params['url_retour_err'] = ""

        params['societe'] = "undefinedSiteCode"

        params=params.merge(options)

        params['date'] = Time.now.strftime("%d/%m/%Y:%H:%M:%S")

        params['reference']=reference
        params['montant']=montant.to_s + "EUR"
        params['TPE']=tpe
        
        params['version'] = "1.2open"

        data = params['TPE'] + "*" + params['date'] + "*" + params['montant'] + "*" + params['reference'] + "*" + params['texte_libre'] + "*" + params['version'] + "*" + params['lgue'] + "*" + params['societe'] + "*"

        params['MAC'] = Cybermut::Helpers.hmac(data,key,pass)


        button=[]
        params.each_pair do |k,v|
          button << tag(:input,:type=>'hidden', :name=>k, :value=>v)
        end                 

        button.join("\n")
    end
    
 
    
     def self.hmac(data,key,pass)
       # clé extraite grâce à extract2HmacSha1.html fourni par le Crédit Mutuel 

       k1 = [Digest::SHA1.hexdigest(pass)].pack("H*");

       l1 = k1.length

       k2 = [key].pack("H*")
       l2 = k2.length

       #if (l1 > l2)
       #  k2 = k2.ljust(l1, chr(0x00))
       #elsif (l2 > l1)
       #  k1 = k1.ljust(l2, chr(0x00))
       #end

       xor_res = k1 ^ k2
       hmac_sha1(xor_res, data).downcase

     end

     def self.hmac_sha1(key, data)
       OpenSSL::HMAC.hexdigest(OpenSSL::Digest::Digest.new("sha1"), key, data)

     end

     protected
     def valid_cybermut_setup_options
         [
           'version',
           'TPE',
           'date',
           'montant',
           'reference',
           'MAC',
           'url_retour',
           'url_retour_ok',
           'url_retour_err',
           'lgue',
           'societe',
           'texte-libre',
           'key',
           'pass'
         ]
       end


  end

end