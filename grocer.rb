require 'pp'
require 'pry'




def find_item_by_name_in_collection(name, collection)
  i = 0 
  
  while i < collection.length
    if collection[i][:item] == name
      return collection[i]
    end
    i += 1 
  end
end


def consolidate_cart(cart) 
  #pp cart 
 new_cart = []
 i = 0
 while i < cart.length do 
new_cart_item = find_item_by_name_in_collection(cart[i][:item], new_cart)
  
  if new_cart_item != nil
    new_cart_item[:count] += 1 
    
  else 
    new_cart_item = {
      :item => cart[i][:item],
      :price => cart[i][:price],
      :clearance => cart[i][:clearance],
      :count => 1
    }
    new_cart << new_cart_item 
  end
  i += 1 
end 
new_cart 
end 





  
  #cart = [{:item => value}{}]
  # Consult README for inputs and outputs
  #
  # REMEMBER: This returns a new Array that represents the cart. Don't merely
  # change `cart` (i.e. mutate) it. It's easier to return a new thing.


def apply_coupons(cart, coupons)
  i = 0 
 
  while i < coupons.length 
    cart_item = find_item_by_name_in_collection(coupons[i][:item], cart)
    couponed_item_name = "#{coupons[i][:item]} W/ COUPON"
    cart_item_with_coupon = find_item_by_name_in_collection(couponed_item_name, cart)
    
    if cart_item && cart_item[:count] >= coupons[i][:num]
     if cart_item_with_coupon
       cart_item_with_coupon[:count] += coupons[i][:num]
       cart_item[:count] -= coupons[i][:num]
     else 
       cart_item_with_coupon = {
       :item => couponed_item_name, 
       :price => coupons[i][:cost] / coupons[i][:num],
       :count => coupons[i][:num],
       :clearance => cart_item[:clearance]
       } 
       cart << cart_item_with_coupon
       cart_item[:count] -= coupons[i][:num]
     end
    end
   i += 1 
 end
 cart
 end




def apply_clearance(cart)
  i = 0 
 while i < cart.length do
 if cart[i][:clearance] 
   cart[i][:price] -= (cart[i][:price] * 0.2).round(2)
 end
  i += 1 
end 
  cart
end

def checkout(cart, coupons)
  new_cart = consolidate_cart(cart)
  couponed_cart = apply_coupons(new_cart)
  final_cart = apply_clearance(couponed_cart)
  i = 0 
  grand_total = 0
  
  while i < final_cart.length do 
  grand_total += final_cart[i][:price] * final_cart[i][:count]
  i += 1
end
  if grand_total > 100.00
    grand_total -= (grand_total * 0.10)
end
grand_total
end
  # Consult README for inputs and outputs
  #
  # This method should call
  # * consolidate_cart
  # * apply_coupons
  # * apply_clearance
  #
  # BEFORE it begins the work of calculating the total (or else you might have
  # some irritated customers

