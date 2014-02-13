# Veritrans VT-Web Ruby wrapper using JSON request

Ruby Wrapper for Veritrans VT-Web. Visit https://www.veritrans.co.id for more information about the product and see documentation at http://docs.veritrans.co.id/vtweb/index.html for more technical details.

## Installation

Add this line to your application's Gemfile:

    gem 'vtweb_json'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install vtweb_json

## Usage

In your Rails app, create 'vtweb.yml' at config directory (config/vtweb.yml) with this code:

    development:
      merchant_id: "T100000000000001XXXXXX"
      merchant_hash_key: "yourmerchanthashkey"
      unfinish_payment_return_url: "http://localhost:3000/cancel_pay"
      finish_payment_return_url: "http://localhost:3000/finish"
      error_payment_return_url: "http://localhost:3000/error"
      vtweb_server: "http://127.0.0.1:4000"

    production:
      merchant_id: "A100000000000001XXXXXX"
      merchant_hash_key: "yourmerchanthashkey"
      unfinish_payment_return_url: "http://yourweb.com/canceled"
      finish_payment_return_url: "http://yourweb.com/thank_you"
      error_payment_return_url: "http://yourweb.com/shop_again"
      
Create a file in 'config/initializers' to set config to vtweb.yml, for example 'store_config.rb':
    
    raw_config = File.read("#{Rails.root}/config/vtweb.yml")
    CONFIG = YAML.load(raw_config)[Rails.env].symbolize_keys
 
      
In your controller, create a method to use the gem. I took the code from https://github.com/veritrans/veritrans-rails-sample-cart for the example with some modification:

    def confirm
      client = ::VtwebJson::Client.new
      client.order_id     = SecureRandom.hex(5)

      # Example 
      @carts = Cart.all
      @total = Cart.select(:sub_total).sum(:sub_total)
  
      params["item"] = []    

      @carts.each do |item|
        params["item"] << { "item_id" => item.product_id, "price" => item.product.price.to_s, "quantity" => item.quantity.to_s, 
                                  "item_name1" => item.product.name, "item_name2" => item.product.name }
      end
  
      client.items    							= params["item"]
      client.billing_different_with_shipping 	= 1
      client.required_shipping_address 			= 1
      client.first_name    						= params[:first_name]
      client.last_name     						= params[:last_name]
      client.address1      						= params[:address1]
      client.address2      						= params[:address2]
      client.city          						= params[:scity]
      client.country_code  						= "IDN"
      client.postal_code   						= params[:postal_code]
      client.phone         						= params[:phone]    
      client.shipping_first_name    			= params[:shipping_first_name]
      client.shipping_last_name     			= params[:shipping_last_name]
      client.shipping_address1      			= params[:shipping_address1]
      client.shipping_address2      			= params[:shipping_address2]
      client.shipping_city          			= params[:shipping_city]
      client.shipping_country_code  			= "IDN"
      client.shipping_postal_code   			= params[:shipping_postal_code]
      client.shipping_phone         			= params[:shipping_phone]  
      client.email 							    = params[:email] 
  
      # Payment Options
      client.promo_bins             			= ['411111', '510510']    
      client.enable_3d_secure      				= 1
      client.installment_banks      			= ['bni', 'cimb', 'mandiri']
      client.installment_terms      			= { bni: [3,12,2], cimb: [3,6,12] }
      client.point_banks            			= ['cimb', 'bni']
      client.bank                   			= 'bni'
      client.payment_methods        			= ['credit_card', 'mandiri_clickpay']

      client.tokens
      @client = client
      @tokens = JSON.parse client.tokens.body
      render :layout => 'application'
    end
    
After you get token_browser and token_merchant, you have to send a http post request merchant_id, order_id and token_browser to redirection url of vtweb. This code was also taken from https://github.com/veritrans/veritrans-rails-sample-cart :

    <h1 align="center">Confirm Purchase Items</h1>
    <%= form_tag(@client.redirection_url, :name => "form_auto_post") do -%>
    	<input type="hidden" name="merchant_id" value="<%= @client._merchant_id %>"> 
    	<input type="hidden" name="order_id" value="<%= @client.order_id %>">
    	<input type="hidden" name="token_browser" value="<%= @tokens["token_browser"] %>">
    	<table border="1" align="center" width="80%" cellpadding="10" bgcolor="#FFFFCC">
      <tr>
        <th>Name</th>
        <th>Price</th>
        <th>Quantity</th>
        <th>Sub Total</th>    
      </tr>
      
      <% for cart in @carts %>
        <tr>
          <td><%= cart.product.name %></td>
          <td><%= cart.product.price %></td>
          <td><%= cart.quantity %></td>
          <td><%= cart.sub_total %></td>
        </tr>    
      <% end %>  
      <tr>
      	<td colspan="2"></td>
      	<td style="text-align=right"><strong>Total</strong></td>
      	<td style="text-align=right"><strong><%= @total %> </strong></td>
      </tr>
    	</table>
    	<br><br>
    	<div align="center">
    	<input type="submit" value="Go to payment page">
    	</div>
    <% end %>

## Contributing

1. Fork it http://github.com/panggi/vtweb_json/fork 
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
