class GalleryItem {
  final String id;
  final String title;
  final String category;
  final String imageUrl;

  const GalleryItem({
    required this.id,
    required this.title,
    required this.category,
    required this.imageUrl,
  });
}

final List<GalleryItem> sampleGalleryItems = [
  const GalleryItem(
    id: 'g1',
    title: 'Luxury Rooftop Ambience',
    category: 'Ambience',
    imageUrl: 'https://images.unsplash.com/photo-1517248135467-4c7edcad34c4',
  ),
  const GalleryItem(
    id: 'g2',
    title: 'Nightclub & Lounge Bar',
    category: 'Nightlife',
    imageUrl: 'https://images.unsplash.com/photo-1572116469696-31de0f17cc34',
  ),
  const GalleryItem(
    id: 'g3',
    title: 'Signature Cocktails',
    category: 'Cocktails',
    imageUrl: 'https://images.unsplash.com/photo-1550547660-d9450f859349',
  ),
  const GalleryItem(
    id: 'g4',
    title: 'Rooftop Special Grill',
    category: 'Food',
    imageUrl: 'https://images.unsplash.com/photo-1544025162-d76694265947',
  ),
  const GalleryItem(
    id: 'g5',
    title: 'Royal Biryani Feast',
    category: 'Food',
    imageUrl: 'https://images.unsplash.com/photo-1600891964599-f61ba0e24092',
  ),
  const GalleryItem(
    id: 'g6',
    title: 'Live DJ & Party Lights',
    category: 'Nightlife',
    imageUrl: 'https://images.unsplash.com/photo-1516450360452-9312f5e86fc7',
  ),
];
