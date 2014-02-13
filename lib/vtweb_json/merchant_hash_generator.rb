module VtwebJson
  module MerchantHashGenerator
    def self.generate(merchant_id, merchant_hash_key, order_id)
      Digest::SHA512.hexdigest("#{merchant_hash_key},#{merchant_id},#{order_id}")
    end
  end
end