import 'package:flutter/material.dart';

class ProductDetailScreen extends StatelessWidget {
  final String imagePath;
  final String productName;
  final String productCode;
  final double price;
  final double rating;
  final String description;

  const ProductDetailScreen({
    super.key,
    required this.imagePath,
    required this.productName,
    required this.productCode,
    required this.price,
    required this.rating,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.yellow[50],
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Stack(
                  children: [
                    Center(
                      child: Image.asset(imagePath,
                          height: 250, fit: BoxFit.cover),
                    ),
                    Positioned(
                      top: 30,
                      right: 16,
                      child: IconButton(
                        icon: const Icon(Icons.close, color: Colors.black),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  productName,
                  style: const TextStyle(
                      fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  productCode,
                  style: const TextStyle(fontSize: 16, color: Colors.grey),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.star, color: Colors.yellow, size: 20),
                    const SizedBox(width: 4),
                    Text(
                      rating.toString(),
                      style: const TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                    const SizedBox(width: 4),
                    const Text(
                      '(xx reviews)',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  '\$$price',
                  style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.red),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Description',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  description,
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                ),
                const SizedBox(height: 8),
                const Text(
                  'See More',
                  style: TextStyle(fontSize: 14, color: Colors.blue),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Comments',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                _buildCommentItem(
                    'assets/user1.png', 'User 1', 'This is a comment.'),
                _buildCommentItem(
                    'assets/user2.png', 'User 2', 'This is another comment.'),
                _buildCommentItem('assets/user3.png', 'User 3',
                    'This is a different comment.'),
                const SizedBox(height: 80), // 하단 고정된 버튼 영역 확보
              ],
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              color: Colors.white,
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  _buildQuantityButton(Icons.remove, () {}),
                  const SizedBox(width: 8),
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Center(
                      child: Text('1'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  _buildQuantityButton(Icons.add, () {}),
                  const Spacer(),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text('Buy'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuantityButton(IconData icon, VoidCallback onPressed) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(8),
      ),
      child: IconButton(
        icon: Icon(icon),
        onPressed: onPressed,
      ),
    );
  }

  Widget _buildCommentItem(String imagePath, String userName, String comment) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            backgroundImage: AssetImage(imagePath),
            radius: 20,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  userName,
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  comment,
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
