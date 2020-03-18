def find_item_by_name_in_collection(name, collection)
  cart_index = 0 
  while cart_index < collection.length do 
    if collection[cart_index][:item] == name 
      return collection[cart_index]
    else 
    cart_index += 1 
  end 
  end 
  return nil 
end

def consolidate_cart(cart)
  new_cart = []
  new_cart << cart[0]
  new_cart[0][:count] = 1 
  cart_index = 1  
  while cart_index < cart.length do 
    new_cart_index = 0 
    bool = true 
    while new_cart_index < new_cart.length do 
      if new_cart[new_cart_index][:item] == cart[cart_index][:item] 
        new_cart[new_cart_index][:count] += 1 
        new_cart_index += 1 
        bool = false 
      else 
        new_cart_index += 1 
      end 
    end 
    if bool == true 
      new_cart << cart[cart_index]
      new_cart[-1][:count] = 1 
    end 
    cart_index += 1 
  end 
  new_cart
end

def apply_coupons(cart, coupons)
  coupons_index = 0 
  while coupons_index < coupons.length do 
  cart_item = find_item_by_name_in_collection(coupons[coupons_index][:item], cart)
  couponed_item_name = "#{coupons[coupons_index][:item]} W/COUPON"
  cart_item_with_coupon = find_item_by_name_in_collection(couponed_item_name, cart)
  if cart_item && cart_item[:count] >= coupons[coupons_index][:num]
    if cart_item_with_coupon
      cart_item_with_coupon[:count] += coupons[coupons_index][:num]
      cart_item[:count] -= coupons[coupons_index][:num]
    else 
      cart_item_with_coupon = {
        :item => couponed_item_name, 
        :price => coupons[coupons_index][:cost] / coupons[coupons_index][:num],
        :count => coupons[coupons_index][:num],
        :clearance => cart_item[:clearance]
      }
      cart << cart_item_with_coupon
      cart_item[:count] -= coupons[coupons_index][:num] 
    end 
  end 
  coupons_index += 1 
end 
cart 
end

def apply_clearance(cart)
  cart_index = 0 
  while cart_index < cart.length do
    if cart[cart_index][:clearance] == true 
      cart[cart_index][:price] -= (0.2 * cart[cart_index][:price])
      cart[cart_index][:price] = cart[cart_index][:price].round(2)
    end 
    cart_index += 1 
  end 
  cart
end

def checkout(cart, coupons)
  # Consult README for inputs and outputs
  #
  # This method should call
  # * consolidate_cart
  # * apply_coupons
  # * apply_clearance
  #
  # BEFORE it begins the work of calculating the total (or else you might have
  # some irritated customers
  consolidated_cart = consolidate_cart(cart)
  couponed_cart = apply_coupons(consolidated_cart, coupons)
  clearanced_cart = apply_clearance(couponed_cart)
  grand_total = 0 
  counter = 0 
  while counter < clearanced_cart.length do 
    grand_total += (clearanced_cart[counter][:price] * clearanced_cart[counter][:count])
    counter += 1 
  end 
  if grand_total > 100
    grand_total -= 0.1 * grand_total
  end 
  grand_total
end
