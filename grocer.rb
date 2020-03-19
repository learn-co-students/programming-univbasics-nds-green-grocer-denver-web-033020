require "pry"

def find_item_by_name_in_collection(name, collection)
  
  array_items = []
  item_index = 0 
  while item_index < collection.length do 
    if collection[item_index][:item] == name
      return collection[item_index]
      
    end
    item_index += 1
  end
  
  # Implement me first!
  #
  # Consult README for inputs and outputs
  
end

def consolidate_cart(cart)
  cart_items = []
  item_count = 0 
  while item_count < cart.length do 
    current_item = find_item_by_name_in_collection(cart[item_count][:item], cart_items)
    if current_item 
      current_item[:count] += 1 
    else
      current_item = {
        :item => cart[item_count][:item],
        :price => cart[item_count][:price],
        :clearance => cart[item_count][:clearance],
        :count => 1 
      }
      cart_items << current_item
    end
    item_count += 1
  end
  
  return cart_items
  # Consult README for inputs and outputs
  #
  # REMEMBER: This returns a new Array that represents the cart. Don't merely
  # change `cart` (i.e. mutate) it. It's easier to return a new thing.
end




def apply_coupons(cart, coupons)
  counter = 0 
  while counter < coupons.length
    cart_item = find_item_by_name_in_collection(coupons[counter][:item], cart)
    coupon_item = "#{coupons[counter][:item]} W/COUPON"
    cart_item_with_coupon = find_item_by_name_in_collection(coupon_item, cart)
    if cart_item && cart_item[:count] >= coupons[counter][:num]
      if cart_item_with_coupon
        cart_item_with_coupon[:count] += coupon[counter][:num]
        cart[:count] -= coupons[counter][:num]
      else
        cart_item_with_coupon = {
          :item => coupon_item,
          :price => coupons[counter][:cost] / coupons[counter][:num],
          :count => coupons[counter][:num],
          :clearance => cart_item[:clearance]
        }
        cart << cart_item_with_coupon
        cart_item[:count] -= coupons[counter][:num]
      end
    end 
    counter += 1
  end
  cart
  # Consult README for inputs and outputs
  #
  # REMEMBER: This method **should** update cart
end

def apply_clearance(cart)
  counter = 0 
  while counter < cart.length
    if cart[counter][:clearance]
      cart[counter][:price] = (cart[counter][:price] - (cart[counter][:price] * 0.20)).round(2)
    end
  counter += 1 
  end
  cart
  # Consult README for inputs and outputs
  #
  # REMEMBER: This method **should** update cart
end

def checkout(cart, coupons)
  consolidated_cart = consolidate_cart(cart)
  couponed_cart = apply_coupons(consolidated_cart, coupons)
  final_cart = apply_clearance(couponed_cart)
  total = 0 
  counter = 0 
  while counter < final_cart.length
    total += final_cart[counter][:price] * final_cart[counter][:count]
    counter += 1 
  end
  if total > 100
    total -= (total * 0.10)
  end
  total
  
  
  
  
  
  # Consult README for inputs and outputs
  #
  # This method should call
  # * consolidate_cart
  # * apply_coupons
  # * apply_clearance
  #
  # BEFORE it begins the work of calculating the total (or else you might have
  # some irritated customers
end
