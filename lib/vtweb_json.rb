$:.unshift File.dirname(__FILE__)

# Required gems
require 'jbuilder'
require 'faraday'
require 'digest/sha2'

# Other Requirements
require "vtweb_json/config"
require "vtweb_json/merchant_hash_generator"
require "vtweb_json/version"

module VtwebJson
  class Client
    include Config
    def initialize(&block)
      class <<self
        self
      end.class_eval do
      attr_accessor :version, :merchant_id, :merchant_hash_key, :order_id, :billing_different_with_shipping, :required_shipping_address,
                    :repeat_line, :item_id, :item_name1, :item_name2, :price, :quantity, :shipping_address1, :shipping_address2, :shipping_city,
                    :shipping_country_code, :shipping_first_name, :shipping_last_name, :shipping_phone, :shipping_postal_code, :email,
                    :payment_methods, :enable_3d_secure, :address1, :address2, :city, :country_code, :first_name, :last_name, :phone, :postal_code,
                    :finish_payment_return_url, :error_payment_return_url, :unfinish_payment_return_url, :bank, :installment_banks, :installment_terms,
                    :point_banks, :promo_bins, :items  
      end
    end
    
    # Define params
    
    def vtweb_server
      return Client.config["vtweb_server"] ? Client.config["vtweb_server"] : Config::VTWEB_SERVER
    end
    
    def redirection_url
      "#{vtweb_server}#{Config::REDIRECTION_URL}"
    end
    
    def _merchant_id
      return Client.config["merchant_id"]
    end
    
    def _merchant_hash_key
      return Client.config["merchant_hash_key"]
    end
    
    def _error_payment_return_url
      return Client.config["error_payment_return_url"]
    end

    def _finish_payment_return_url
      return Client.config["finish_payment_return_url"]
    end

    def _unfinish_payment_return_url
      return Client.config["unfinish_payment_return_url"]
    end
    
    # Calculate Merchant Hash
    
    def merchanthash
      return MerchantHashGenerator::generate(_merchant_id, _merchant_hash_key, self.order_id);
    end
    
    # Build JSON from defined params
    
    def build_json

      Jbuilder.encode do |json|
        # Required Params
        json.version 1
        json.merchant_id _merchant_id
        json.merchanthash merchanthash
        json.order_id self.order_id
        json.billing_different_with_shipping self.billing_different_with_shipping
        json.required_shipping_address self.required_shipping_address
        json.repeat_line self.items.length
        item_id = []
        item_name1 = []
        item_name2 = []
        price = []
        quantity = []
        self.items.each do |item|
          item_id << item['item_id']
          json.item_id item_id
          
          item_name1 << item['item_name1']
          json.item_name1 item_name1
          
          item_name2 << item['item_name2']
          json.item_name2 item_name2
          
          price << item['price']
          json.price price
          
          quantity << item['quantity']
          json.quantity quantity
        end
        
        # Required if required_shipping_address = 1
        json.shipping_address1 self.shipping_address1
        json.shipping_address2 self.shipping_address2
        json.shipping_city self.shipping_city
        json.shipping_country_code self.shipping_country_code
        json.shipping_first_name self.shipping_first_name
        json.shipping_last_name self.shipping_last_name
        json.shipping_phone self.shipping_phone
        json.shipping_postal_code self.shipping_postal_code
        json.email self.email
        
        # Optional Params
        json.payment_methods self.payment_methods
        json.enable_3d_secure self.enable_3d_secure
        json.address1 self.address1
        json.address2 self.address2
        json.city self.city
        json.country_code self.country_code
        json.first_name self.first_name
        json.last_name self.last_name
        json.phone self.phone
        json.postal_code self.postal_code
        json.finish_payment_return_url _finish_payment_return_url
        json.error_payment_return_url _error_payment_return_url
        json.unfinish_payment_return_url _unfinish_payment_return_url
        json.bank self.bank
        json.installment_banks self.installment_banks
        json.installment_terms self.installment_terms
        json.point_banks self.point_banks
        json.promo_bins self.promo_bins
      end
    end
    
    # Get Token
    
    def tokens
      conn = Faraday.new(:url => vtweb_server) do |faraday|            
        faraday.adapter  Faraday.default_adapter  
      end
      
      response = conn.post do |request|
        request.url GET_TOKENS_URL
        request.headers['Content-Type'] = 'application/json'
        request.headers['Accept'] = 'application/json'
        request.body = build_json
      end
      
    end  
  end  
end
