print("Welcome to Zapiz!, What pizza would you like to order?")

# pizza
pizza <- c("Double Cheese", "Chicken Trio", "Seafood Deluxe")

# size
size = c("S", "M", "L")
size_price = c(399, 599, 799)
names(size_price) <- size

# appitizers
appitizers = c("Fish Fingers", "Fried chicken", "Garlic Bread")
appitizers_price = c(109, 99, 59)
names(appitizers_price) <- appitizers

# store
store <- c("Siam Paragon", "Samyan Mitrtown", "Central World")

print(pizza)

count_order_pizza <- 0
while (count_order_pizza >= 0) {
  order_pizza <- readLines("stdin", n=1)
  count_order_pizza <- count_order_pizza +1

    if (order_pizza == "Double Cheese" | order_pizza == "Chicken Trio" | order_pizza == "Seafood Deluxe") {
    print(order_pizza)
    break
      } else {
        print("Please select pizza again")
        print(pizza)
      }
    }


print("Select size")
print(size_price)

count_order_size <- 0
while (count_order_size >= 0) {
  order_size <- readLines("stdin", n=1)
  count_order_size <- count_order_size + 1
    
    if (order_size == "S" | order_size == "M"| order_size == "L") {
      #print(order_size)
      print(size_price[[order_size]])
      break
    } else {
      print("Please select size again")
      print(size_price)
    }
}

print("How many pizza would you like to order?")
nums_pizza <- as.numeric(readLines("stdin", n=1))
print(nums_pizza)

print("Would you like to order appitizers? (Yes/No)")
yn_appitizers <- readLines("stdin", n=1)

if (yn_appitizers == "Yes") {
  print("Select appitizer")
  print(appitizers_price)

  count_order_appitizers <- 0
  while (count_order_appitizers >= 0){
    order_appitizers <- readLines("stdin", n=1)
    count_order_appitizers <- count_order_appitizers + 1
    
    if (order_appitizers == "Fish Fingers" | order_appitizers == "Fried chicken"| order_appitizers == "Garlic Bread") {
      #print(order_appitizers)
      print(appitizers_price[[order_appitizers]])
      break
    } else {
      print("Select appitizer again")
      print(appitizers_price)
    }  
  }
  
  print("How many appitizers would you like to order?")
  nums_appitizers <- as.numeric(readLines("stdin", n=1))
  print(nums_appitizers)
} else {
  print(yn_appitizers)
}

print("Delivery or Takeaway")
order_type <- readLines("stdin", n=1)
print(order_type)

if(order_type == "Delivery") {
  print("Please select your address")
  cus_address <- readLines("stdin", n=1)
  delivery_fee <- 50
  print(cus_address)
} else {
  print("Please select store")
  print(store)
  selected_store <- readLines("stdin", n=1)
  delivery_fee <- 0
  print()
}

food_amount <- sum(
                   size_price[[order_size]] * nums_pizza,
                   appitizers_price[[order_appitizers]] * nums_appitizers
                  )

total_amount <- sum(
                   size_price[[order_size]] * nums_pizza,
                   appitizers_price[[order_appitizers]] * nums_appitizers,
                   delivery_fee
                  )

print(paste("Food amount: ", food_amount))
print(paste("Delivery fee: ", delivery_fee))
print(paste("Total amount: ", total_amount))



