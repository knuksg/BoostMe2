import 'package:flutter/material.dart';
import 'product_detail_screen.dart';

class ShoppingScreen extends StatelessWidget {
  const ShoppingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Products',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildCategoryItem(
                  context, 'assets/images/moisturizer.jpg', 'Moisturizer'),
              _buildCategoryItem(
                  context, 'assets/images/cleanser.jpg', 'Cleanser'),
              _buildCategoryItem(
                  context, 'assets/images/lip_care.jpg', 'Lip Care'),
              _buildCategoryItem(context, 'assets/images/toner.jpg', 'Toner'),
              _buildCategoryItem(context, 'assets/images/powder.jpg', 'Powder'),
            ],
          ),
          const SizedBox(height: 20),
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                childAspectRatio: 0.7,
              ),
              itemCount: 10, // 임의의 상품 개수
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ProductDetailScreen(
                          imagePath: 'assets/images/product.jpg', // 임의의 제품 이미지
                          productName: 'Sun screen SPF 30 your Brand',
                          productCode: '000123487655',
                          price: 20.5,
                          rating: 4.5,
                          description:
                              'Lorem ipsum sit dolor amet Lorem ipsum sit dolor amet Lorem ipsum sit dolor amet Lorem ipsum sit dolor amet',
                        ),
                      ),
                    );
                  },
                  child: _buildProductItem(context),
                );
              },
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Most Popular',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          _buildPopularItem(context, 'Serum your Brand', 'Cosmetic 20ml',
              'assets/images/serum.jpg', 11.9),
          _buildPopularItem(context, 'Sun screen SPF 30', 'your Brand',
              'assets/images/sunscreen.jpg', 9.8),
        ],
      ),
    );
  }

  Widget _buildCategoryItem(
      BuildContext context, String imagePath, String label) {
    return Column(
      children: [
        Image.asset(imagePath, width: 40, height: 40),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(fontSize: 12),
        ),
      ],
    );
  }

  Widget _buildProductItem(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.lightBlue[50],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Image.asset('assets/images/product.jpg'), // 임의의 제품 이미지
            ),
            const SizedBox(height: 8),
            const Text(
              'Name product',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const Text(
              'name product ml',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
            const SizedBox(height: 8),
            const Text(
              '\$7.7',
              style: TextStyle(
                  fontSize: 16, fontWeight: FontWeight.bold, color: Colors.red),
            ),
            const Align(
              alignment: Alignment.centerRight,
              child: Icon(Icons.favorite_border, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPopularItem(BuildContext context, String name,
      String description, String imagePath, double price) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Image.asset(imagePath, width: 60, height: 60),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Text(
                description,
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
              Text(
                '\$$price',
                style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.red),
              ),
            ],
          ),
          const Spacer(),
          const Icon(Icons.favorite_border, color: Colors.grey),
        ],
      ),
    );
  }
}
