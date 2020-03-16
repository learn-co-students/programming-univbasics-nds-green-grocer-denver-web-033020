require 'pry'
require 'pp'

def find_item_by_name_in_collection(name, collection)
  # Implement me first!
  #
  # Consult README for inputs and outputs
  # Find a specific item using its name inside of the collection array
  item_counter_index = 0
  while item_counter_index < collection.length do
    if collection[item_counter_index][:item] == name
      return collection[item_counter_index] # Will return the elemenet and EXIT THE LOOP AND METHOD
    end
    item_counter_index += 1
  end
  nil
end

def consolidate_cart(cart)
  # Consult README for inputs and outputs
  #
  # REMEMBER: This returns a new Array that represents the cart. Don't merely
  # change `cart` (i.e. mutate) it. It's easier to return a new thing.
  # Will return AoH [{:item => "AVOCADO", :price => 3.00, :clearance => true, :count => 2}]
  # Item: {:item => "AVOCADO", :price => 3.00, :clearance => true, :count => 2}
  new_cart = []
  item_counter_index = 0
  while item_counter_index < cart.length do
    # binding.pry
    new_cart_item = find_item_by_name_in_collection(cart[item_counter_index][:item], new_cart)
    if new_cart_item != nil # Truthy
      new_cart_item[:count] += 1
    else
      new_cart_item = {
        :item => cart[item_counter_index][:item],
        :price => cart[item_counter_index][:price],
        :clearance => cart[item_counter_index][:clearance],
        :count => 1
      }
      new_cart << new_cart_item
    end
  item_counter_index += 1
  end
  new_cart
end

def apply_coupons(cart, coupons)
  # Consult README for inputs and outputs
  #
  # REMEMBER: This method **should** update cart
  counter = 0
   while counter < coupons.length
    cart_item = find_item_by_name_in_collection(coupons[counter][:item], cart)
    couponed_item_name = "#{coupons[counter][:item]} W/COUPON"
    cart_item_with_coupon = find_item_by_name_in_collection(couponed_item_name, cart)

    # If the found cart item exists and there is enough of that item
    if cart_item && cart_item[:count] >= coupons[counter][:num]

      # If this item has already had a coupon applied
      if cart_item_with_coupon
        # Add the number of couponable items to the couponed item that already exists
        cart_item_with_coupon[:count] += coupons[counter][:num]

        # Then subtract that same number from the remaining number of the non-couponed item in the cart (the leftover extra items)
        cart_item[:count] -= coupons[counter][:num]

      else
        # Create a new cart item with coupon hash
        cart_item_with_coupon = {

          :item => couponed_item_name,
          :price => coupons[counter][:cost] / coupons[counter][:num],
          :count => coupons[counter][:num],
          :clearance => cart_item[:clearance]
        }

        cart << cart_item_with_coupon

        # Subtract the number of couponed items from the original hash
        cart_item[:count] -= coupons[counter][:num]
      end
    end
    counter += 1
   end
   cart
end

def apply_clearance(cart)
  # Consult README for inputs and outputs
  #
  # REMEMBER: This method **should** update cart
  counter = 0
  while counter < cart.length
    if cart[counter][:clearance]
      cart[counter][:price] = (cart[counter][:price] - (cart[counter][:price] * 0.20)).round(2)
    end
    counter += 1
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
  # BEFORE it begins the work of calculating the total (or else you might have
  # some irritated customers
  consolidated_cart = consolidate_cart(cart)
  couponed_cart = apply_coupons(consolidated_cart, coupons)
  final_cart = apply_clearance(couponed_cart)

  total = 0
  counter = 0
  while counter < final_cart.length do
    total += final_cart[counter][:price] * final_cart[counter][:count]
    counter += 1
  end
  if total > 100
    total -= (total * 0.10)
  end
  total
end
