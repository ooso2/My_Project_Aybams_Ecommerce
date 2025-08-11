# db/seeds.rb - AYBAMS E-commerce Platform

# Clear existing data
puts "Clearing existing data..."
OrderItem.delete_all
Payment.delete_all
Order.delete_all
ProductPrice.delete_all
Product.delete_all
Category.delete_all
Page.delete_all
User.delete_all

puts "Creating admin user..."
admin = User.create!(
  email: 'admin@aybams.ca',
  password: 'password123',
  password_confirmation: 'password123',
  first_name: 'Admin',
  last_name: 'User',
  role: 'admin',
  address: '123 Admin Street',
  city: 'Winnipeg',
  province: 'MB',
  postal_code: 'R3B 1A1',
  country: 'Canada',
  phone: '(204) 555-0001'
)

puts "Creating test customer..."
customer = User.create!(
  email: 'customer@example.com',
  password: 'password123',
  password_confirmation: 'password123',
  first_name: 'Jane',
  last_name: 'Doe',
  role: 'customer',
  address: '456 Customer Ave',
  city: 'Winnipeg',
  province: 'MB',
  postal_code: 'R3B 2C3',
  country: 'Canada',
  phone: '(204) 555-0002'
)

puts "Creating categories..."
categories_data = [
  {
    name: 'Kitchen & Dining',
    description: 'Sustainable kitchenware and dining essentials for eco-conscious cooking and entertaining.',
    children: [
      { name: 'Bamboo Utensils', description: 'Eco-friendly bamboo cutlery and serving utensils' },
      { name: 'Glass Storage', description: 'Durable glass containers for food storage' },
      { name: 'Organic Textiles', description: 'Cotton dish towels and kitchen linens' }
    ]
  },
  {
    name: 'Home Decor',
    description: 'Beautiful, sustainable decor items to enhance your living space naturally.',
    children: [
      { name: 'Soy Candles', description: 'Hand-poured soy wax candles with natural fragrances' },
      { name: 'Reclaimed Wood', description: 'Furniture and decor made from reclaimed materials' },
      { name: 'Natural Fiber Rugs', description: 'Sustainable rugs made from natural fibers' }
    ]
  },
  {
    name: 'Personal Care',
    description: 'Natural and organic personal care products for healthy, conscious living.',
    children: [
      { name: 'Organic Soaps', description: 'Handmade soaps with natural ingredients' },
      { name: 'Zero Waste Beauty', description: 'Plastic-free beauty and skincare products' },
      { name: 'Natural Skincare', description: 'Organic skincare products for all skin types' }
    ]
  },
  {
    name: 'Textiles',
    description: 'Sustainable bedding, towels, and clothing accessories made from organic materials.',
    children: [
      { name: 'Organic Bedding', description: 'Comfortable bedding made from organic cotton' },
      { name: 'Hemp Towels', description: 'Absorbent and durable hemp bath towels' },
      { name: 'Sustainable Accessories', description: 'Eco-friendly clothing accessories' }
    ]
  },
  {
    name: 'Specialty Items',
    description: 'Unique artisan crafts and seasonal items from local Manitoba makers.',
    children: [
      { name: 'Local Artisan Crafts', description: 'Handmade items from Manitoba artisans' },
      { name: 'Seasonal Gift Sets', description: 'Curated gift collections for special occasions' },
      { name: 'Cleaning Supplies', description: 'Eco-friendly cleaning products' }
    ]
  }
]

categories = {}
categories_data.each do |cat_data|
  parent = Category.create!(
    name: cat_data[:name],
    description: cat_data[:description],
    active: true,
    sort_order: categories.count
  )
  categories[cat_data[:name]] = parent

  cat_data[:children].each_with_index do |child_data, index|
    child = Category.create!(
      name: child_data[:name],
      description: child_data[:description],
      parent: parent,
      active: true,
      sort_order: index
    )
    categories[child_data[:name]] = child
  end
end

puts "Creating products..."
products_data = [
  # Kitchen & Dining Products
  {
    name: 'Bamboo Cutlery Set',
    short_description: 'Complete bamboo cutlery set with carrying case',
    description: 'This beautiful bamboo cutlery set includes a fork, knife, spoon, and chopsticks, all made from sustainable bamboo. Perfect for on-the-go dining or reducing plastic waste at home.',
    current_price: 24.99,
    compare_at_price: 29.99,
    stock_quantity: 45,
    category: categories['Bamboo Utensils'],
    sku: 'AYB-BCU-001',
    weight: 0.2,
    dimensions: '20 x 5 x 2 cm',
    featured: true,
    on_sale: true,
    material: 'Organic Bamboo',
    origin_country: 'Canada',
    sustainability_info: 'Made from 100% organic bamboo, this cutlery set is biodegradable and helps reduce single-use plastic waste.'
  },
  {
    name: 'Glass Food Storage Containers',
    short_description: 'Set of 4 borosilicate glass containers with bamboo lids',
    description: 'These premium borosilicate glass containers are perfect for storing leftovers, meal prep, or pantry organization. The bamboo lids create an airtight seal to keep food fresh longer.',
    current_price: 39.99,
    stock_quantity: 32,
    category: categories['Glass Storage'],
    sku: 'AYB-GFS-002',
    weight: 1.5,
    dimensions: 'Various sizes included',
    featured: true,
    material: 'Borosilicate Glass, Bamboo',
    origin_country: 'Canada',
    sustainability_info: 'Made from durable borosilicate glass that can last a lifetime, reducing the need for disposable containers.'
  },
  {
    name: 'Organic Cotton Dish Towels (Set of 3)',
    short_description: 'Absorbent organic cotton kitchen towels',
    description: 'These super-absorbent dish towels are made from 100% organic cotton. They become more absorbent with each wash and are perfect for all kitchen tasks.',
    current_price: 18.99,
    stock_quantity: 67,
    category: categories['Organic Textiles'],
    sku: 'AYB-ODT-003',
    weight: 0.3,
    dimensions: '40 x 70 cm each',
    material: 'Organic Cotton',
    origin_country: 'Canada',
    sustainability_info: 'Grown without harmful pesticides, these towels support sustainable farming practices.'
  },

  # Home Decor Products
  {
    name: 'Lavender Soy Candle',
    short_description: 'Hand-poured soy wax candle with organic lavender',
    description: 'This calming lavender candle is hand-poured using natural soy wax and organic essential oils. Burns cleanly for up to 40 hours.',
    current_price: 28.99,
    compare_at_price: 34.99,
    stock_quantity: 28,
    category: categories['Soy Candles'],
    sku: 'AYB-LSC-004',
    weight: 0.5,
    dimensions: '8 x 8 x 10 cm',
    on_sale: true,
    material: 'Soy Wax, Organic Essential Oils',
    origin_country: 'Manitoba, Canada',
    sustainability_info: 'Made with 100% natural soy wax that burns cleaner than paraffin and supports local Manitoba beekeepers.'
  },
  {
    name: 'Reclaimed Wood Floating Shelf',
    short_description: 'Rustic floating shelf made from reclaimed barn wood',
    description: 'Each shelf is unique, crafted from authentic Manitoba barn wood. Perfect for displaying plants, books, or decorative items.',
    current_price: 89.99,
    stock_quantity: 15,
    category: categories['Reclaimed Wood'],
    sku: 'AYB-RWS-005',
    weight: 2.8,
    dimensions: '60 x 20 x 5 cm',
    featured: true,
    material: 'Reclaimed Manitoba Barn Wood',
    origin_country: 'Manitoba, Canada',
    sustainability_info: 'Each shelf saves old barn wood from landfills while celebrating Manitoba\'s agricultural heritage.'
  },

  # Personal Care Products
  {
    name: 'Honey Oat Soap Bar',
    short_description: 'Moisturizing soap with Manitoba honey and oats',
    description: 'This gentle, moisturizing soap is made with local Manitoba honey and finely ground oats. Perfect for sensitive skin.',
    current_price: 8.99,
    stock_quantity: 156,
    category: categories['Organic Soaps'],
    sku: 'AYB-HOS-006',
    weight: 0.12,
    dimensions: '8 x 5 x 3 cm',
    material: 'Organic Oils, Manitoba Honey, Oats',
    origin_country: 'Manitoba, Canada',
    sustainability_info: 'Made with locally sourced honey supporting Manitoba beekeepers and sustainable agriculture.'
  },
  {
    name: 'Bamboo Toothbrush (Pack of 4)',
    short_description: 'Biodegradable bamboo toothbrushes with soft bristles',
    description: 'Replace plastic toothbrushes with these eco-friendly bamboo alternatives. Soft bristles are gentle on teeth and gums.',
    current_price: 16.99,
    stock_quantity: 89,
    category: categories['Zero Waste Beauty'],
    sku: 'AYB-BTB-007',
    weight: 0.08,
    dimensions: '19 x 2 x 1 cm each',
    material: 'Bamboo, Natural Bristles',
    origin_country: 'Canada',
    sustainability_info: 'Bamboo handles are 100% biodegradable, helping reduce plastic waste in our oceans.'
  },

  # Textiles
  {
    name: 'Organic Cotton Sheet Set',
    short_description: 'Luxurious organic cotton sheets - Queen size',
    description: 'Sleep soundly in these incredibly soft organic cotton sheets. The fabric gets softer with every wash while maintaining durability.',
    current_price: 129.99,
    compare_at_price: 159.99,
    stock_quantity: 23,
    category: categories['Organic Bedding'],
    sku: 'AYB-OCS-008',
    weight: 1.8,
    dimensions: 'Queen size fitted and flat sheet with pillowcases',
    on_sale: true,
    featured: true,
    material: 'Certified Organic Cotton',
    origin_country: 'Canada',
    sustainability_info: 'GOTS certified organic cotton grown without harmful chemicals, supporting farmer health and soil quality.'
  },
  {
    name: 'Hemp Bath Towel Set',
    short_description: 'Ultra-absorbent hemp towels (set of 2)',
    description: 'These hemp towels are naturally antimicrobial and become more absorbent over time. Perfect for everyday use.',
    current_price: 54.99,
    stock_quantity: 34,
    category: categories['Hemp Towels'],
    sku: 'AYB-HBT-009',
    weight: 1.2,
    dimensions: '70 x 140 cm each',
    material: 'Hemp Fiber',
    origin_country: 'Canada',
    sustainability_info: 'Hemp requires 50% less water to grow than cotton and naturally improves soil health.'
  },

  # Specialty Items
  {
    name: 'Manitoba Artisan Pottery Mug',
    short_description: 'Handcrafted ceramic mug by local Manitoba potter',
    description: 'Each mug is unique, wheel-thrown by skilled Manitoba artisans. Perfect for your morning coffee or evening tea.',
    current_price: 32.99,
    stock_quantity: 41,
    category: categories['Local Artisan Crafts'],
    sku: 'AYB-MAP-010',
    weight: 0.4,
    dimensions: '10 x 8 x 12 cm',
    featured: true,
    material: 'Local Clay, Food-Safe Glaze',
    origin_country: 'Manitoba, Canada',
    sustainability_info: 'Made with local Manitoba clay and fired in energy-efficient kilns, supporting local artisan communities.'
  },
  {
    name: 'Holiday Gift Set - Eco Essentials',
    short_description: 'Curated collection of eco-friendly essentials',
    description: 'This beautiful gift set includes a bamboo cutlery set, organic soap, soy candle, and reusable cotton bag. Perfect for introducing someone to sustainable living.',
    current_price: 79.99,
    compare_at_price: 95.99,
    stock_quantity: 18,
    category: categories['Seasonal Gift Sets'],
    sku: 'AYB-HGS-011',
    weight: 1.1,
    dimensions: '30 x 25 x 10 cm gift box',
    on_sale: true,
    featured: true,
    material: 'Various sustainable materials',
    origin_country: 'Canada',
    sustainability_info: 'A perfect introduction to sustainable living, each item in this set helps reduce environmental impact.'
  },
  {
    name: 'Plant-Based All-Purpose Cleaner',
    short_description: 'Concentrated eco-friendly cleaning solution',
    description: 'This powerful plant-based cleaner tackles grease and grime without harsh chemicals. Safe for families and pets.',
    current_price: 12.99,
    stock_quantity: 73,
    category: categories['Cleaning Supplies'],
    sku: 'AYB-PAC-012',
    weight: 0.6,
    dimensions: '20 x 6 x 6 cm',
    material: 'Plant-based surfactants, Essential oils',
    origin_country: 'Canada',
    sustainability_info: 'Biodegradable formula that\'s safe for waterways and made with renewable plant-based ingredients.'
  }
]

puts "Creating individual products..."
products_data.each_with_index do |product_data, index|
  product = Product.create!(
    name: product_data[:name],
    short_description: product_data[:short_description],
    description: product_data[:description],
    current_price: product_data[:current_price],
    compare_at_price: product_data[:compare_at_price],
    stock_quantity: product_data[:stock_quantity],
    category: product_data[:category],
    sku: product_data[:sku],
    weight: product_data[:weight],
    dimensions: product_data[:dimensions],
    is_active: true,
    featured: product_data[:featured] || false,
    on_sale: product_data[:on_sale] || false,
    material: product_data[:material],
    origin_country: product_data[:origin_country],
    sustainability_info: product_data[:sustainability_info]
  )

  # Create price history
  ProductPrice.create!(
    product: product,
    price: product.current_price,
    start_date: 30.days.ago,
    is_active: true,
    reason: 'initial_price'
  )

  puts "Created product: #{product.name}"
end

puts "Creating sample pages..."
Page.create!(
  title: 'About Us',
  slug: 'about',
  content: %{
    # About AYBAMS

    Welcome to AYBAMS, Winnipeg's premier destination for sustainable living products. Founded 8 years ago with a simple mission: to make eco-friendly living accessible, beautiful, and affordable for everyone in Manitoba and beyond.

    ## Our Story

    AYBAMS began in the heart of Winnipeg's Exchange District, where our founders noticed a gap in the market for high-quality, ethically-sourced home goods. What started as a small boutique has grown into a thriving business with 35 dedicated team members, but our core values remain unchanged.

    ## Our Commitment

    We believe that sustainability shouldn't mean compromising on style or quality. Every product we carry is carefully curated to meet our strict standards for:

    - **Environmental Impact**: Products that minimize harm to our planet
    - **Social Responsibility**: Supporting fair trade and ethical manufacturing
    - **Quality Craftsmanship**: Items built to last, reducing waste through durability
    - **Local Community**: Prioritizing Manitoba and Canadian-made products whenever possible

    ## Why Choose AYBAMS?

    - **Curated Selection**: Every product is hand-picked by our sustainability experts
    - **Educational Focus**: We provide detailed information about each product's environmental benefits
    - **Community Support**: We partner with local artisans and Manitoba-based suppliers
    - **Transparency**: Full disclosure of materials, origins, and manufacturing processes

    Visit our flagship store in Winnipeg's Exchange District, find us at local farmers' markets, or shop online for convenient delivery across Canada.

    Together, we're building a more sustainable future, one thoughtful purchase at a time.
  },
  published: true,
  sort_order: 1
)

Page.create!(
  title: 'Contact Us',
  slug: 'contact',
  content: %{
    # Get In Touch

    We'd love to hear from you! Whether you have questions about our products, need help with an order, or want to learn more about sustainable living, our team is here to help.

    ## Store Information

    **AYBAMS Flagship Store**
    123 Exchange Avenue
    Winnipeg, MB R3B 1A1
    Canada

    **Phone**: (204) 555-0123
    **Email**: info@aybams.ca

    **Store Hours**:
    - Monday - Friday: 10:00 AM - 7:00 PM
    - Saturday: 9:00 AM - 6:00 PM
    - Sunday: 11:00 AM - 5:00 PM

    ## Find Us at Local Markets

    We love connecting with our community! You can find AYBAMS at:

    - **Winnipeg Farmers' Market**: Saturdays, 8:00 AM - 3:00 PM
    - **St. Norbert Farmers' Market**: Saturdays, 8:00 AM - 2:00 PM
    - Various seasonal pop-up locations throughout Manitoba

    ## Customer Service

    Our customer service team is available:
    - **Monday - Friday**: 9:00 AM - 6:00 PM (Central Time)
    - **Email Response Time**: Within 24 hours
    - **Phone Support**: Available during business hours

    ## Wholesale Inquiries

    Interested in carrying AYBAMS products in your store? We work with cafes, boutiques, and retailers across Manitoba. Contact our wholesale team at wholesale@aybams.ca for more information.

    ## Sustainability Questions

    Have questions about the environmental impact of our products? Our sustainability team loves sharing knowledge! Email us at sustainability@aybams.ca for detailed information about any product's eco-credentials.
  },
  published: true,
  sort_order: 2
)

puts "Creating sample orders..."
# Create some sample orders for demonstration
3.times do |i|
  # Calculate totals manually for seeding
  subtotal = 0
  order_items_data = []

  # Prepare order items data first
  products_sample = Product.limit(3).offset(i * 2)
  products_sample.each do |product|
    quantity = rand(1..3)
    item_total = product.current_price * quantity
    subtotal += item_total

    order_items_data << {
      product: product,
      quantity: quantity,
      price_at_purchase: product.current_price,
      subtotal: item_total
    }
  end

  # Calculate other amounts
  tax_amount = subtotal * 0.13 # 13% HST for Manitoba
  shipping_cost = subtotal >= 75 ? 0 : 9.99 # Free shipping over $75
  total_amount = subtotal + tax_amount + shipping_cost

  # Create order with calculated totals
  order = Order.create!(
    user: customer,
    order_date: (i + 1).days.ago,
    status: ['pending', 'processing', 'shipped'][i],
    subtotal: subtotal,
    tax_amount: tax_amount,
    shipping_cost: shipping_cost,
    total_amount: total_amount,
    shipping_first_name: customer.first_name,
    shipping_last_name: customer.last_name,
    shipping_address: customer.address,
    shipping_city: customer.city,
    shipping_province: customer.province,
    shipping_postal_code: customer.postal_code,
    shipping_country: customer.country,
    shipping_phone: customer.phone,
    billing_first_name: customer.first_name,
    billing_last_name: customer.last_name,
    billing_address: customer.address,
    billing_city: customer.city,
    billing_province: customer.province,
    billing_postal_code: customer.postal_code,
    billing_country: customer.country,
    billing_phone: customer.phone
  )

  # Create order items
  order_items_data.each do |item_data|
    OrderItem.create!(
      order: order,
      product: item_data[:product],
      quantity: item_data[:quantity],
      price_at_purchase: item_data[:price_at_purchase],
      subtotal: item_data[:subtotal]
    )
  end

  # Create payment
  Payment.create!(
    order: order,
    payment_method: 'credit_card',
    payment_status: 'completed',
    amount: order.total_amount,
    transaction_id: "TXN#{SecureRandom.hex(8).upcase}",
    payment_date: order.order_date
  )

  puts "Created order #{order.order_number} with total: $#{order.total_amount}"
end

puts "\n" + "="*50
puts "AYBAMS E-commerce Platform Setup Complete!"
puts "="*50
puts ""
puts "Admin Login:"
puts "Email: admin@aybams.ca"
puts "Password: password123"
puts ""
puts "Customer Login:"
puts "Email: customer@example.com"
puts "Password: password123"
puts ""
puts "Database contains:"
puts "- #{Category.count} categories"
puts "- #{Product.count} products"
puts "- #{User.count} users"
puts "- #{Order.count} sample orders"
puts "- #{Page.count} content pages"
puts ""
puts "Start the server with: rails server"
puts "Visit: http://localhost:3000"