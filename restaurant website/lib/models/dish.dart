class Dish {
  final String id;
  final String name;
  final String category;
  final double price;
  final String description;
  final String imageUrl;
  final bool isVeg;
  final String tag;
  final double rating;

  const Dish({
    required this.id,
    required this.name,
    required this.category,
    required this.price,
    required this.description,
    required this.imageUrl,
    required this.isVeg,
    this.tag = '',
    this.rating = 4.8,
  });
}

final List<Dish> sampleDishes = [
  const Dish(
    id: '1',
    name: 'Royal Mughlai Biryani',
    category: 'Mughlai',
    price: 349,
    description: 'Slow-cooked aromatic basmati rice cooked with authentic spices & tender marinated meat.',
    imageUrl: 'https://images.unsplash.com/photo-1600891964599-f61ba0e24092',
    isVeg: false,
    tag: "Chef's Special",
    rating: 4.9,
  ),
  const Dish(
    id: '2',
    name: 'Upper Deck Special Paneer Tikka',
    category: 'Starters',
    price: 279,
    description: 'Fresh cottage cheese cubes marinated in rich Indian spices and chargrilled in tandoor.',
    imageUrl: 'https://images.unsplash.com/photo-1567188040759-fb8a883dc6d8',
    isVeg: true,
    tag: 'Bestseller',
    rating: 4.8,
  ),
  const Dish(
    id: '3',
    name: 'Signature Rooftop Grilled Chicken',
    category: 'Main Course',
    price: 399,
    description: 'Juicy chicken breasts infused with herb butter sauce and served with roasted veggies.',
    imageUrl: 'https://images.unsplash.com/photo-1544025162-d76694265947',
    isVeg: false,
    tag: 'Rooftop Special',
    rating: 4.9,
  ),
  const Dish(
    id: '4',
    name: 'Golden Sunset Sunset Cocktail',
    category: 'Cocktails',
    price: 429,
    description: 'Crafted mix of vodka, passionfruit liqueur, fresh lime & gold edible shimmer.',
    imageUrl: 'https://images.unsplash.com/photo-1550547660-d9450f859349',
    isVeg: true,
    tag: 'Nightlife Special',
    rating: 4.9,
  ),
  const Dish(
    id: '5',
    name: 'Galouti Kebab Sizzler',
    category: 'Mughlai',
    price: 389,
    description: 'Melt-in-mouth Awadhi minced kebabs served hot on a sizzler plate with mint chutney.',
    imageUrl: 'https://images.unsplash.com/photo-1599487488170-d11ec9c172f0',
    isVeg: false,
    tag: 'Must Try',
    rating: 4.8,
  ),
  const Dish(
    id: '6',
    name: 'Crispy Honey Chilli Lotus Stem',
    category: 'Starters',
    price: 249,
    description: 'Tossed lotus stem crisps glazed with hot garlic honey sauce and toasted sesame.',
    imageUrl: 'https://images.unsplash.com/photo-1541544741938-0af808871cc0',
    isVeg: true,
    tag: 'Crispy',
    rating: 4.7,
  ),
  const Dish(
    id: '7',
    name: 'Blue Lagoon Night Mocktail',
    category: 'Cocktails',
    price: 249,
    description: 'Refreshing blue curaçao syrup, sparkling soda, fresh mint leaves & lemon zests.',
    imageUrl: 'https://images.unsplash.com/photo-1513558161293-cdaf765ed2fd',
    isVeg: true,
    tag: 'Popular',
    rating: 4.7,
  ),
  const Dish(
    id: '8',
    name: 'Sizzling Brownie with Ice Cream',
    category: 'Desserts',
    price: 229,
    description: 'Rich dark chocolate brownie served piping hot with vanilla bean ice cream & hot fudge.',
    imageUrl: 'https://images.unsplash.com/photo-1606313564200-e75d5e30476c',
    isVeg: true,
    tag: 'Sweet Delight',
    rating: 4.9,
  ),
];
