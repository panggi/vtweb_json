require "yaml"

module VtwebJson

  module Config
    
    # Server
    VTWEB_SERVER         = "https://vtweb.veritrans.co.id"
    GET_TOKENS_URL       = "/v1/tokens.json"
    REDIRECTION_URL      = "/v1/payments.json"

    # Params Config
    BILLING_DIFFERENT_WITH_SHIPPING = '0'

    def Config.included(mod)
      class <<self
        template = {
          'merchant_id' => nil,
          'merchant_hash_key' => nil,
          'finish_payment_return_url' => nil,
          'unfinish_payment_return_url' => nil,
          'error_payment_return_url' => nil,
          'vtweb_server' => nil
        }
        
        @@config_env = ::Object.const_defined?(:Rails) ? Rails.env : "development"
        @@config = File.exists?("./config/vtweb.yml") ? YAML.load_file("./config/vtweb.yml") : {}
        @@config['development'] = {} if !@@config['development']
        @@config['production' ] = {} if !@@config['production']
        @@config['development'] = template.clone.merge(@@config['development'])
        @@config['production']  = template.clone.merge(@@config['production'])
      end

      mod.instance_eval <<CODE

      def self.config_env=(env)
        @@config_env = env
      end

      def self.config
        @@config[@@config_env]
      end 
CODE

    end
  end
end