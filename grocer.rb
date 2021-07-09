# require 'pry'
require 'pp'

def find_item_by_name_in_collection(name, collection)
  # pp collection
  
  i = 0
  while i < collection.length  
    if name == collection[i][:item]
      # pp collection[i][:item]
      return collection[i]
    end
    i += 1
  end
end

def consolidate_cart(cart)
  # REMEMBER: This returns a new Array that represents the cart. Don't merely
  # change `cart` (i.e. mutate) it. It's easier to return a new thing.
  
  consolidatedCart = []
  # pp cart
 
  i = 0
  while i < cart.length # go through cart
    x = 0
    dupCheck = false
    while x < consolidatedCart.length # checking for duplicates
      if consolidatedCart[x] == cart[i]
        consolidatedCart[x][:count] += 1
        dupCheck = true
      end
      x += 1
    end
    
    if dupCheck == false
      consolidatedCart[i] = cart[i]
      consolidatedCart[i][:count] = 1
    end
    i += 1
  end
  
  y = 0
  while y < consolidatedCart.length
    if consolidatedCart[y] == nil
      consolidatedCart.delete_at(y)
    else 
      y += 1
    end
  end 
  # puts "Final array: #{pp consolidatedCart}"
  consolidatedCart
end

def apply_coupons(cart, coupons)
 
 # instead of looping through the entire cart and comparing each one to the coupons, since the coupons are so much less in number, it makes sense to loop through the coupons and find cart item by its name. It is much more efficient, less steps required to find the answers 
 counter = 0
 while counter < coupons.length
  cart_item = find_item_by_name_in_collection(coupons[counter][:item], cart)
  couponed_item_name = "#{coupons[counter][:item]} W/COUPON"
  cart_item_with_coupon = find_item_by_name_in_collection(couponed_item_name, cart)

  # if the found cart item exists and has enough of that item
  if cart_item && cart_item[:count] >= coupons[counter][:num]
    
    # if this item has already had a coupon applied 
    if cart_item_with_coupon
      # add the number of couponable items to the couponed item that already exists 
      cart_item_with_coupon[:count] += coupons[counter][:num]
      
      # then subtract that same number from the non-couponed item in the cart (the leftover extra items)
      cart_item[:count] -= coupons[counter][:num]
      
    else  
      # create a new cart item with coupon hash
      cart_item_with_coupon = {
        
        :item => couponed_item_name, 
        :price => coupons[counter][:cost] / coupons[counter][:num], 
        :count => coupons[counter][:num], 
        :clearance => cart_item[:clearance]
      }
      
      cart << cart_item_with_coupon
      
      # subtract the number of couponed items from the original hash
      cart_item[:count] -= coupons[counter][:num]
    end
  end
  counter += 1
 end
 cart
end

def apply_clearance(cart)

  count = 0
  while count < cart.length
    
    if cart[count][:clearance] == true
      
      cart[count][:price] = cart[count][:price] - (0.2 * cart[count][:price])
      
    end
    count += 1
  end
  
  cart
end

def checkout(cart, coupons)

  finalCart = consolidate_cart(cart)
  finalCoupons = apply_coupons(finalCart, coupons)
  clearances = apply_clearance(finalCoupons)

  finalCost = 0
  count = 0
  while count < finalCoupons.length
    
    finalCost += finalCoupons[count][:price] * finalCoupons[count][:count]
    
    count += 1
  end

  if finalCost > 100
    finalCost = finalCost - (0.1 * finalCost)
  end
  
  Float finalCost
end