def find_item_by_name_in_collection(name, collection)
  # Implement me first!
  #
  # Consult README for inputs and outputs

  i = 0
  while i < collection.count do
    if collection[i][:item] == name
      return collection[i]
    end
    i += 1
  end
end

# new_item => item to be added to the cart
# cart => array of hashes, with each hash representing the count of distinct items
def add_item_to_cart(new_item, cart)
  # iterate through the items in the cart
  # if the item already exists; increment the count of that item
  i = 0
  item_found = false
  while i < cart.count do
    if new_item[:name] == cart[i][:name]
      cart[i][:count] += 1
      item_found = true
    end
    i += 1
  end

  # if the item does NOT already exist in the cart, add the item to the cart
  if !item_found
    item_to_add = {
      :item => new_item[:item],
      :price => new_item[:price],
      :clearance => new_item[:clearance],
      :count => 1
    }
    cart << item_to_add
  end
  cart
end

def consolidate_cart(cart)
  sm_cart = []
  lg_index = 0
  while lg_index < cart.count do
    added = false
    sm_index = 0
    while sm_index < sm_cart.count do
      if sm_cart[sm_index][:item] == cart[lg_index][:item]
        # the item already exists in the cart
        qty = sm_cart[sm_index][:count] + 1
        sm_cart[sm_index][:count] = qty
        added = true
      end
      sm_index += 1
    end

    if !added
      new_item = {
        :item => cart[lg_index][:item],
        :price => cart[lg_index][:price],
        :clearance => cart[lg_index][:clearance],
        :count => 1
      }
      sm_cart << new_item
    end

    lg_index += 1
  end
  return sm_cart
end

def apply_coupons(cart, coupons)
  # input:
  # - ary (collection of cart item hashes, already consolidated)
  # - ary (collection of coupon hashes)
  # output:
  # - new ary of hashes (collection of cart items with coupons applied)
  #   - where applicable: "ITEM W/COUPON"
  result = []
  for cur_item in cart do
    coupon_applied = false
    for cur_coupon in coupons do
      if cur_item[:item] == cur_coupon[:item] and cur_item[:count] >= cur_coupon[:num]
        # We have more than enough items to apply the coupon
        # create the discounted item
        discounted_item = create_discounted_item(cur_item, cur_coupon)
        # decrement the remaining items
        cur_item[:count] = cur_item[:count] - cur_coupon[:num]
        # add the items to the output
        result << cur_item
        result << discounted_item
        # denote we applied the coupon
        coupon_applied = true
      end
    end
    if !coupon_applied
      result << cur_item
    end
  end
  return result
end



def create_discounted_item(item, coupon)
  discounted_item = {
    :item => item[:item] + " W/COUPON",
    :price => coupon[:cost] / coupon[:num],
    :clearance => item[:clearance],
    :count => coupon[:num]
  }
  return discounted_item
end


def apply_clearance(cart)
  # Arguments:
  # --> Cart = array of item hashes
  # Returns:
  # --> a new Array where every unique item in the original is present but with its price
  #     reduced by 20% of value is true
  result = []
  for cur_item in cart do
    if cur_item[:clearance]
      cur_item[:price] = (cur_item[:price] * 0.8).round(2)
      result << cur_item
    else
      result << cur_item
    end
  end
  return result
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
  consolidated_cart_w_coupons = apply_coupons(consolidated_cart, coupons)
  final_cart = apply_clearance(consolidated_cart_w_coupons)

  total = 0
  for grocery_item in final_cart do
    item_cost = grocery_item[:price] * grocery_item[:count]
    total += item_cost
  end

  if total > 100
    total = total * 0.9
  end

  return total
end



# returns an AoAoH
# Top Level Array:
#   pos[1] => Array of consolidated grocery items (cart)
# #   pos[2] => Array of coupons
# def create_test_data()
#   grocery_items = [
#     {:item => "AVOCADO", :price => 3.00, :clearance => true, :count => 3},
#     {:item => "KALE",    :price => 3.00, :clearance => false, :count => 1},
#     {:item => "PEANUT BUTTER", :price => 3.00, :clearance => true,  :count => 2},
#     {:item => "KALE", :price => 3.00, :clearance => false, :count => 3},
#     {:item => "SOY MILK", :price => 4.50, :clearance => true,  :count => 1}
#   ]
#   coupons = [{:item => "AVOCADO", :num => 2, :cost => 5.00}]

#   return grocery_items, coupons
# end
# test_data = create_test_data()
# p 'Cart'
# p test_data[0]
# puts 'Coupon'
# p test_data[1]
# p 'checkout'
# p checkout(test_data[0], test_data[1]) 
