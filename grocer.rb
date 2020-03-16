

def find_item_by_name_in_collection(name, collection)
  # Implement me first!
  #
  # Consult README for inputs and outputs
  
  result = {}
  i=0
  
  while i <collection.length do
    if collection[i][:item] == name
      result = collection[i]
      return result
    end
    i+=1
  end
  nil
  
end

def consolidate_cart(cart)
  # Consult README for inputs and outputs
  #
  # REMEMBER: This returns a new Array that represents the cart. Don't merely
  # change `cart` (i.e. mutate) it. It's easier to return a new thing.
  
  result = []
  i=0
  
  while i < cart.length
    #item_name=cart[i][:item]
    new_cart_item = find_item_by_name_in_collection(cart[i][:item],result)
      if new_cart_item != nil
        new_cart_item[:count] += 1
      else
        new_cart_item = {
          :item => cart[i][:item],
          :price => cart[i][:price],
          :clearance => cart[i][:clearance],
          :count => 1
        }
        result << new_cart_item
      end
      
      i+=1
  end
  
  return result
      
end

def apply_coupons(cart, coupons)
  # Consult README for inputs and outputs
  #
  # REMEMBER: This method **should** update cart
  i=0
  while i <coupons.length
    item = find_item_by_name_in_collection(coupons[i][:item],cart)
    item_name_with_coupon = "#{coupons[i][:item]} W/COUPON"
    cart_item_with_coupon= find_item_by_name_in_collection(item_name_with_coupon,cart)
    if item && item[:count] >= coupons[i][:num]
      if cart_item_with_coupon
        cart_item_with_coupon[:count] += coupons[i][:num]
        item[:count] -= coupons[i][:num]
      else
        cart_item_with_coupon = {
          :item => item_name_with_coupon,
          :price => coupons[i][:cost] / coupons[i][:num],
          :count => coupons[i][:num],
          :clearance => item[:clearance]
        }
        cart << cart_item_with_coupon
        item[:count] -= coupons[i][:num]
      end
    end
    i+=1
  end
  
  return cart
end

def apply_clearance(cart)
  # Consult README for inputs and outputs
  #
  # REMEMBER: This method **should** update cart
  
  result=[]
  i=0
  
  while i < cart.length
    if cart[i][:clearance]
      cart[i][:price] = (cart[i][:price] * 0.80).round(2)
    end
    i+=1
  end
  return cart
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
  couponed_cart = apply_coupons(consolidated_cart,coupons)
  cart_final = apply_clearance(couponed_cart)
  
  i=0
  total=0
  
  while i < cart_final.length
    total += cart_final[i][:price]* cart_final[i][:count]
    i+=1
  end
  
  if total > 100
    total= total * 0.90
  end
  
  return total
  
end
