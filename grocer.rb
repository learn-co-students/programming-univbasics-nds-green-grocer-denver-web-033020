def find_item_by_name_in_collection(name, collection)
 index = 0
 while index < collection.length do
  if collection[index][:item] == name
    return collection[index]
  end
  index += 1
 end
end

def consolidate_cart(cart)
 new_cart = []
 index = 0
 while index < cart.length do
   new_item = find_item_by_name_in_collection(cart[index][:item], new_cart)
   if new_item == nil
     new_item = {
       item: cart[index][:item],
       price: cart[index][:price],
       clearance: cart[index][:clearance],
       count: 1
       }
      new_cart << new_item 
    else
      new_item[:count] += 1
    end  
   index += 1
 end
 new_cart
end

def apply_coupons(cart, coupons)
  index = 0
  
  while index < coupons.length do
    full_price_item = find_item_by_name_in_collection(coupons[index][:item], cart)
    discounted_item_name = "#{coupons[index][:item]} W/COUPON"
    discounted_item = find_item_by_name_in_collection(discounted_item_name, cart)
    
    if full_price_item != nil && full_price_item[:count] >= coupons[index][:num]
      if discounted_item != nil
        discounted_item[:count] += coupons[index][:num]
        full_price_item[:count] -= coupons[index][:num]
      else
        discounted_item = {
          :item => "#{coupons[index][:item]} W/COUPON",
          :price => coupons[index][:cost] / coupons[index][:num],
          :count => coupons[index][:num],
          :clearance => full_price_item[:clearance]
        }
        cart << discounted_item
        full_price_item[:count] -= coupons[index][:num]
      end
    end
    
    index += 1
  end
  
  cart
end

def apply_clearance(cart)
 index = 0
 clearance_cart_applied = []
 while index < cart.length do
   clearance_item = find_item_by_name_in_collection(cart[index][:item], cart)
   if clearance_item[:clearance]
     clearance_applied = clearance_item[:price] *= 0.8
     clearance_item[:price] = clearance_applied.round(2)
   end
   clearance_cart_applied << clearance_item
   index += 1
 end
 clearance_cart_applied
end

def checkout(cart, coupons)
  cart_total = 0
  consolidated_cart = consolidate_cart(cart)
  cart_with_coupons_applied = apply_coupons(consolidated_cart, coupons)
  cart_with_all_discounts_applied = apply_clearance(cart_with_coupons_applied)
  index = 0
  
  while index < cart_with_all_discounts_applied.length do
    item_total = cart_with_all_discounts_applied[index][:price] * cart_with_all_discounts_applied[index][:count]
    cart_total += item_total
    index += 1
  end
  
  if cart_total > 100
    cart_total *= 0.9
  end
  
  cart_total
end
