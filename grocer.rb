
def find_item_by_name_in_collection(name, collection)
  i = 0 
  while i < collection.length do
    if collection[i][:item] == name
      return collection[i]
    end
    i += 1
   end 
  
  # Implement me first!
  #
  # Consult README for inputs and outputs
end

def consolidate_cart(cart)
  item_count_cart = []
  i = 0
  while i < cart.length do
    new_item = find_item_by_name_in_collection(cart[i][:item], item_count_cart)
    #same method as before to find an item, but now looking in item_count_cart and using cart data set
    if new_item !=nil
      # if the item is present in item_coutn cart (if it's not not present)
    new_item[:count] += 1 
    #if the item is present in the item_count_cart we will access the item's :count and increase it by 1 
  else 
    # if the item isn't present yet in the item_count_cart we will add it as a hash WITH :counter
    new_item = {
      :item => cart[i][:item],
      :price => cart[i][:price],
      :clearance => cart[i][:clearance],
      :count => 1 }
      #original hash didnt have this count, so we can set it to 1, and it will go up if more are added
    
    item_count_cart.push(new_item)
  #to summarize: if item already exists in our item_count_cart we are going to increase it's count by 1. or else we are gonna create the new hash with :count of 1
  end
    i += 1
end
 item_count_cart
end
def apply_coupons(cart, coupons)
  i = 0 
  while i < coupons.length
  #loops over the list of coupons 
    cart_item = find_item_by_name_in_collection(coupons[i][:item], cart)
    # looks for items in the coupon list that match items in our cart
    
    couponned_item_name = "#{coupons[i][:item]} W/COUPON"
    #takes items that match an puts them in this string that we made
    
    cart_item_with_coupon = find_item_by_name_in_collection(couponned_item_name, cart)
    #looks to see if this string for a given item is already in our cart_item
    if cart_item && cart_item[:count] >= coupons[i][:num]
      #if the item on the coupon is in our cart and there are are enough items to use the coupon
      
      if cart_item_with_coupon
        cart_item_with_coupon[:count] += coupons[i][:num]
        cart_item[:count] -= coupons[i][:num]
        #if there is the string already in our cart, we add the number of coupons to that item
        # we also have to take it out of the cart that doesnt have the  string so we can add them together later
    else
      cart_item_with_coupon = {
        :item => couponned_item_name,
        :price => coupons[i][:cost] / coupons[i][:num],
        :count => coupons[i][:num],
        :clearance => cart_item[:clearance]
      }
        #if the string didnt previously exist we need to create a new hash with the string
      cart << cart_item_with_coupon
      #then we add the updated hashes to our cart
      cart_item[:count] -= coupons[i][:num]
      #and we have to remove the couponned items from the original list 
    end
  end
  i += 1 
end
cart
end

def apply_clearance(cart)
  i = 0 
  while i < cart.length
  if cart[i][:clearance] == true
    cart[i][:price] = (cart[i][:price] - (cart[i][:price] * 0.2)).round(2)
    #rounds to two decimal places
  end
  i += 1
end
cart
end

def checkout(cart, coupons)
  cart_consolidated = consolidate_cart(cart)
  coupons_applied = apply_coupons(cart_consolidated, coupons)
  cart_after_clearance = apply_clearance(coupons_applied)
  
  total_spent = 0 
  i = 0 
  while i < cart_after_clearance.length
  total_spent += cart_after_clearance[i][:price] * cart_after_clearance[i][:count]
  i += 1 
end
  if total_spent > 100
    total_spent -= (total_spent * 0.1)
end
  total_spent
end