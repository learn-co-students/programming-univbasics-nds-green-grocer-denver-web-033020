require 'pry'

def find_item_by_name_in_collection(name, collection)
  i = 0
  while i < collection.length do
    if name == collection[i][:item]
      return collection[i]
    end
    i += 1
  end
end


def consolidate_cart(cart)
  new_cart = []
  i = 0 
  while i < cart.length do
    item_name = cart[i][:item]
    new_cart_item = find_item_by_name_in_collection(item_name, new_cart)
   
    if new_cart_item != nil
      new_cart_item[:count] += 1
      
    else
      new_cart_item = {
        :item => cart[i][:item],
        :price => cart[i][:price],
        :clearance => cart[i][:clearance],
        :count => 1 }
        
      new_cart << new_cart_item
    end
    i += 1
    
  end
  new_cart 
end

def apply_coupons(cart, coupons)
  i = 0 
  while i < coupons.length do
    cart_item = find_item_by_name_in_collection(coupons[i][:item], cart)
    couponed_item = "#{coupons[i][:item]} W/COUPON"
    cart_item_w_coupon = find_item_by_name_in_collection(couponed_item, cart)
    if cart_item && cart_item[:count] >= coupons[i][:num]
      if cart_item_w_coupon
        cart_item_w_coupon[:count] += coupons[i][:num]
        cart_item[:count] -= coupons[i][:num]
      else
        cart_item_w_coupon = {
          :item => couponed_item,
          :price => coupons[i][:cost] / coupons[i][:num],
          :count => coupons[i][:num],
          :clearance => cart_item[:clearance]
        }
        cart << cart_item_w_coupon
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
      cart[i][:price] = (cart[i][:price] - (cart[i][:price] * 0.20)).round(2)
    end
    i += 1
  end
  cart
end

def checkout(cart, coupons)
  consolidated_cart = consolidate_cart(cart)
  couponed_cart = apply_coupons(consolidated_cart, coupons)
  clearance_and_coupons_applied = apply_clearance(couponed_cart)
  total = 0
  i = 0 
  
  while i < clearance_and_coupons_applied.length do
    total += clearance_and_coupons_applied[i][:price] * clearance_and_coupons_applied[i][:count]
    i += 1
  end
  if total > 100
    total -= (total * 0.10)
  end
  total
end