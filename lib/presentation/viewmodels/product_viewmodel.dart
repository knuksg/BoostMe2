import 'package:boostme2/core/provider.dart';
import 'package:boostme2/domain/repositories/product_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:boostme2/domain/entities/product.dart';

class ProductViewModel extends StateNotifier<AsyncValue<List<Product>>> {
  final ProductRepository _productRepository;

  ProductViewModel(this._productRepository)
      : super(const AsyncValue.loading()) {
    loadProductsByCategory(
        'Moisturizer'); // Load default category products on initialization
  }

  Future<void> loadProducts() async {
    try {
      final products = await _productRepository.getProducts();
      state = AsyncValue.data(products);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  Future<void> loadProductsByCategory(String category) async {
    state = const AsyncValue.loading();
    try {
      final products = await _productRepository.getProductsByCategory(category);
      state = AsyncValue.data(products);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  Future<List<Product>> loadPopularProducts() async {
    try {
      final products = await _productRepository.getPopularProducts();
      return products;
    } catch (e) {
      rethrow;
    }
  }
}

final productViewModelProvider =
    StateNotifierProvider<ProductViewModel, AsyncValue<List<Product>>>((ref) {
  final productRepository = ref.watch(productRepositoryProvider);
  return ProductViewModel(productRepository);
});
