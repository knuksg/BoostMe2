import 'package:carousel_slider/carousel_slider.dart';
import 'package:boostme2/domain/entities/product.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../viewmodels/product_viewmodel.dart';
import 'product_detail_screen.dart';

class ShoppingScreen extends ConsumerWidget {
  const ShoppingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productsState = ref.watch(productViewModelProvider);

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
                  context, 'assets/images/moisturizer.jpg', 'Moisturizer', ref),
              _buildCategoryItem(
                  context, 'assets/images/cleanser.jpg', 'Cleanser', ref),
              _buildCategoryItem(
                  context, 'assets/images/lip_care.jpg', 'Lip Care', ref),
              _buildCategoryItem(
                  context, 'assets/images/toner.jpg', 'Toner', ref),
              _buildCategoryItem(
                  context, 'assets/images/powder.jpg', 'Powder', ref),
            ],
          ),
          const SizedBox(height: 20),
          const Text(
            'Most Popular',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          _buildPopularItemsCarousel(context, ref),
          const SizedBox(height: 20),
          Expanded(
            child: productsState.when(
              data: (products) {
                if (products.isEmpty) {
                  return const Center(child: Text('No products found'));
                }
                return GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    childAspectRatio: 0.7,
                  ),
                  itemCount: products.length,
                  itemBuilder: (context, index) {
                    final product = products[index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ProductDetailScreen(
                              imagePath: product.imageUrl,
                              productName: product.name,
                              productCode: product.id.toString(),
                              price: product.price,
                              rating: 4.5, // 임의의 값 사용
                              description: product.description,
                            ),
                          ),
                        );
                      },
                      child: _buildProductItem(context, product),
                    );
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stackTrace) =>
                  Center(child: Text(error.toString())),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryItem(
      BuildContext context, String imagePath, String label, WidgetRef ref) {
    return InkWell(
      onTap: () {
        ref
            .read(productViewModelProvider.notifier)
            .loadProductsByCategory(label);
      },
      child: Column(
        children: [
          Image.asset(imagePath, width: 40, height: 40),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _buildProductItem(BuildContext context, Product product) {
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
              child: Stack(
                children: [
                  Positioned.fill(
                    child: Image.asset(
                        'assets/images/default_product.png'), // 기본 이미지 경로
                  ),
                  Positioned.fill(
                    child: Image.network(
                      product.imageUrl,
                      fit: BoxFit.cover,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Center(
                          child: CircularProgressIndicator(
                            value: loadingProgress.expectedTotalBytes != null
                                ? loadingProgress.cumulativeBytesLoaded /
                                    loadingProgress.expectedTotalBytes!
                                : null,
                          ),
                        );
                      },
                      errorBuilder: (context, error, stackTrace) {
                        return Image.asset(
                            'assets/images/default_product.png'); // 기본 이미지 경로
                      },
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              product.name,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Text(
              '${product.stockQuantity} ml',
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
            const SizedBox(height: 8),
            Text(
              '\$${product.price}',
              style: const TextStyle(
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

  Widget _buildPopularItemsCarousel(BuildContext context, WidgetRef ref) {
    final popularProductsAsyncValue =
        ref.watch(productViewModelProvider.notifier).loadPopularProducts();

    return FutureBuilder<List<Product>>(
      future: popularProductsAsyncValue,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text(snapshot.error.toString()));
        } else if (snapshot.hasData) {
          final products = snapshot.data!;
          return CarouselSlider.builder(
            itemCount: products.length,
            itemBuilder: (context, index, realIndex) {
              final product = products[index];
              return _buildCarouselItem(context, product);
            },
            options: CarouselOptions(
              height: 200,
              enlargeCenterPage: true,
              autoPlay: true,
              aspectRatio: 16 / 9,
              autoPlayCurve: Curves.fastOutSlowIn,
              enableInfiniteScroll: true,
              autoPlayAnimationDuration: const Duration(milliseconds: 800),
              viewportFraction: 0.8,
            ),
          );
        } else {
          return const Center(child: Text('No popular products found'));
        }
      },
    );
  }

  Widget _buildCarouselItem(BuildContext context, Product product) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductDetailScreen(
              imagePath: product.imageUrl,
              productName: product.name,
              productCode: product.id.toString(),
              price: product.price,
              rating: 4.5, // 임의의 값 사용
              description: product.description,
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.all(5.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          color: Colors.grey[200],
        ),
        child: Stack(
          children: [
            Positioned.fill(
              child:
                  Image.asset('assets/images/default_product.png'), // 기본 이미지 경로
            ),
            Positioned.fill(
              child: Image.network(
                product.imageUrl,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Center(
                    child: CircularProgressIndicator(
                      value: loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded /
                              loadingProgress.expectedTotalBytes!
                          : null,
                    ),
                  );
                },
                errorBuilder: (context, error, stackTrace) {
                  return Image.asset(
                      'assets/images/default_product.png'); // 기본 이미지 경로
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
