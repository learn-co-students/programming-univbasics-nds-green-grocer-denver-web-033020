require 'pry'

def find_item_by_name_in_collection(name, collection)

index = 0
  while index < collection.length do
    if collection[index][:item] == name
    return collection[index]
  end
  index +=1
  end
end
  # Implement me first!
  #
  # Consult README for inputs and outputs

  # * Arguments:
  #   * `String`: name of the item to find
  #   * `Array`: a collection of items to search through
  # * Returns:
  #   * `nil` if no match is found
  #   * the matching `Hash` if a match is found between the desired name and a given
  #     `Hash`'s :item key

def consolidate_cart(cart)

  index = 0
  consolidated_cart = []

while index < cart.length do
  consolidated_cart_item = find_item_by_name_in_collection(cart[index][:item], consolidated_cart)
  item_name = cart[index][:item]
if consolidated_cart_item != nil
    consolidated_cart_item[:count] += 1
else
consolidated_cart_item = {
  :item => cart[index][:item],
  :price  => cart[index][:price],
  :clearance  => cart[index][:clearance],
  :count =>1
}
  consolidated_cart << consolidated_cart_item
  end
  index += 1
  end
  consolidated_cart
end
# Consult README for inputs and outputs
  #
  # REMEMBER: This returns a new Array that represents the cart. Don't merely
  # change `cart` (i.e. mutate) it. It's easier to return a new thing.
def apply_coupons(cart, coupons)
  # Consult README for inputs and outputs
  #
  # REMEMBER: This method **should** update cart
  index = 0

  while index < coupons.length do
    cart_item = find_item_by_name_in_collection(coupons[index][:item], cart)
    couponed_item_name = "#{coupons[index][:item]} W/COUPON"
    cart_item_with_coupon = find_item_by_name_in_collection(couponed_item_name, cart)
      if cart_item && cart_item[:count] >= coupons[index][:num]
          if cart_item_with_coupon
            cart_item_with_coupon[:count] += coupons[index][:num]
              cart_item[:count] -= coupons[index][:num]
          else
            cart_item_with_coupon = {
            :item => couponed_item_name,
            :price => coupons[index][:cost] / coupons[index][:num],
            :count => coupons[index][:num],
            :clearance => cart_item[:clearance]
}
cart << cart_item_with_coupon
cart_item[:count] -= coupons[index][:num]
          end
        end
        index += 1
      end
      cart
  end

def apply_clearance(cart)
  # Consult README for inputs and outputs
  #
  # REMEMBER: This method **should** update cart
  index = 0
  while index < cart.length do
    if cart[index][:clearance]
    cart[index][:price] = ((cart[index][:price]) - (cart[index][:price]* 0.20)).round(2)
end
 index += 1
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
  final_cart = apply_clearance(consolidated_cart)
total = 0
index = 0
while index < final_cart.length
total += final_cart[index][:price] * final_cart[index][:count]
index +=1
end
if total > 100
  total -= (total * 0.10)
end
total
end
