require 'pp'
def find_item_by_name_in_collection(name, collection)
  i = 0 
  new_collection = {}
  while i < collection.length do 
    if collection[i][:item] == name
      return collection[i]
    else 
      nil
    end
    i += 1 
  end 
end

def consolidate_cart(cart)
  i = 0 
  result = []
  while i < cart.length do 
    name_item = find_item_by_name_in_collection(cart[i][:item], result)
    if name_item
      name_item[:count] += 1 
    else 
      name_item = {
        :item => cart[i][:item], 
        :price => cart[i][:price], 
        :clearance => cart[i][:clearance], 
        :count => 1 
      }
      result << name_item
    end 
    i += 1 
  end 
  result
end

def apply_coupons(cart, coupons)
  coupon_item = {}
  i = 0 
  while i < coupons.length do 
    cart_items = find_item_by_name_in_collection(coupons[i][:item], cart)
    new_coupon_name = "#{coupons[i][:item]} W/COUPON"
    cart_items_with_coupon = find_item_by_name_in_collection(new_coupon_name, cart)
    if cart_items && cart_items[:count] >= coupons[i][:num]
      if cart_items_with_coupon 
        cart_items_with_coupon[:count] += coupons[i][:num]
        cart_items[:count] -= coupons[i][:num]
      else 
         coupon_item = {
           :item => new_coupon_name, 
           :price => (coupons[i][:cost] / coupons[i][:num]),
           :clearance => cart_items[:clearance],
           :count => coupons[i][:num]
         }
         cart_items[:count] -= coupons[i][:num]
         cart << coupon_item
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
      cart[i][:price] = (cart[i][:price] - (cart[i][:price] * 0.2)).round(2)
    end 
  i += 1 
end 
cart 
end

def checkout(cart, coupons)
  new_cart = consolidate_cart(cart)
  new_coupon = apply_coupons(new_cart, coupons)
  new_clearance = apply_clearance(new_coupon)
  total = 0 
  i = 0 
  while i< new_clearance.length do 
    total += new_clearance[i][:price] * new_clearance[i][:count]
    i += 1
  end 
  if total > 100 
    total = total - (total * 0.1)
  end 
  total
end
