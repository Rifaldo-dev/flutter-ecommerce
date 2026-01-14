import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ecommerce_ui/features/widgets/animated_button.dart';
import 'package:ecommerce_ui/features/widgets/animated_icon_button.dart';
import 'package:ecommerce_ui/features/widgets/animation_types.dart';
import 'package:ecommerce_ui/controllers/cart_controller.dart';

class ButtonDemoScreen extends StatelessWidget {
  const ButtonDemoScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cartController = Get.find<CartController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Animated Buttons Demo'),
        leading: AnimatedIconButton(
          icon: Icons.arrow_back,
          onPressed: () => Get.back(),
          animationType: AnimationType.scale,
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Section: Basic Animated Buttons
            _buildSection(
              'Basic Animated Buttons',
              [
                AnimatedElevatedButton(
                  text: 'Scale Animation',
                  onPressed: () => _showSnackbar('Scale button pressed!'),
                ),
                const SizedBox(height: 12),
                AnimatedButton(
                  text: 'Ripple Effect',
                  onPressed: () => _showSnackbar('Ripple button pressed!'),
                  animationType: AnimationType.ripple,
                  backgroundColor: Colors.green,
                ),
                const SizedBox(height: 12),
                AnimatedButton(
                  text: 'Fade Animation',
                  onPressed: () => _showSnackbar('Fade button pressed!'),
                  animationType: AnimationType.fade,
                  backgroundColor: Colors.orange,
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Section: Buttons with Icons
            _buildSection(
              'Buttons with Icons',
              [
                AnimatedElevatedButton(
                  text: 'Add to Cart',
                  icon:
                      const Icon(Icons.add_shopping_cart, color: Colors.white),
                  onPressed: () => _showSnackbar('Added to cart!'),
                ),
                const SizedBox(height: 12),
                AnimatedButton(
                  text: 'Download',
                  icon: const Icon(Icons.download, color: Colors.white),
                  onPressed: () => _showSnackbar('Downloading...'),
                  backgroundColor: Colors.blue,
                  animationType: AnimationType.ripple,
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Section: Loading States
            _buildSection(
              'Loading States',
              [
                AnimatedElevatedButton(
                  text: 'Loading Button',
                  isLoading: true,
                  onPressed: null, // Disabled when loading
                ),
                const SizedBox(height: 12),
                AnimatedButton(
                  text: 'Processing...',
                  isLoading: true,
                  backgroundColor: Colors.purple,
                  animationType: AnimationType.fade,
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Section: Outlined Buttons
            _buildSection(
              'Outlined Buttons',
              [
                AnimatedOutlinedButton(
                  text: 'Cancel',
                  onPressed: () => _showSnackbar('Cancelled!'),
                  borderColor: Colors.red,
                  textColor: Colors.red,
                ),
                const SizedBox(height: 12),
                AnimatedOutlinedButton(
                  text: 'Save Draft',
                  icon: const Icon(Icons.save_outlined),
                  onPressed: () => _showSnackbar('Draft saved!'),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Section: Icon Buttons
            _buildSection(
              'Animated Icon Buttons',
              [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      children: [
                        AnimatedIconButton(
                          icon: Icons.favorite_border,
                          onPressed: () => _showSnackbar('Liked!'),
                          color: Colors.red,
                          animationType: AnimationType.scale,
                        ),
                        const Text('Scale', style: TextStyle(fontSize: 12)),
                      ],
                    ),
                    Column(
                      children: [
                        AnimatedIconButton(
                          icon: Icons.share,
                          onPressed: () => _showSnackbar('Shared!'),
                          color: Colors.blue,
                          animationType: AnimationType.rotation,
                        ),
                        const Text('Rotation', style: TextStyle(fontSize: 12)),
                      ],
                    ),
                    Column(
                      children: [
                        AnimatedIconButton(
                          icon: Icons.notifications,
                          onPressed: () => _showSnackbar('Notification!'),
                          color: Colors.orange,
                          animationType: AnimationType.pulse,
                        ),
                        const Text('Pulse', style: TextStyle(fontSize: 12)),
                      ],
                    ),
                    Column(
                      children: [
                        AnimatedIconButton(
                          icon: Icons.star,
                          onPressed: () => _showSnackbar('Starred!'),
                          color: Colors.amber,
                          animationType: AnimationType.bounce,
                        ),
                        const Text('Bounce', style: TextStyle(fontSize: 12)),
                      ],
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Section: Specialized Buttons
            _buildSection(
              'Specialized Buttons',
              [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      children: [
                        AnimatedFavoriteButton(
                          isFavorite: false,
                          onPressed: () => _showSnackbar('Favorite toggled!'),
                        ),
                        const Text('Favorite', style: TextStyle(fontSize: 12)),
                      ],
                    ),
                    Column(
                      children: [
                        Obx(() => AnimatedCartButton(
                              onPressed: () => _showSnackbar('Cart opened!'),
                              itemCount: cartController.itemCount,
                            )),
                        const Text('Cart', style: TextStyle(fontSize: 12)),
                      ],
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Section: Custom Styled Buttons
            _buildSection(
              'Custom Styled Buttons',
              [
                AnimatedButton(
                  text: 'Gradient Button',
                  onPressed: () => _showSnackbar('Gradient pressed!'),
                  width: double.infinity,
                  height: 60,
                  borderRadius: BorderRadius.circular(30),
                  backgroundColor: Colors.deepPurple,
                  animationType: AnimationType.scale,
                ),
                const SizedBox(height: 12),
                AnimatedButton(
                  text: 'Rounded Square',
                  onPressed: () => _showSnackbar('Square pressed!'),
                  width: double.infinity,
                  height: 50,
                  borderRadius: BorderRadius.circular(8),
                  backgroundColor: Colors.teal,
                  animationType: AnimationType.ripple,
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Test cart functionality
            _buildSection(
              'Test Cart Animation',
              [
                AnimatedElevatedButton(
                  text: 'Add Item to Cart',
                  icon: const Icon(Icons.add, color: Colors.white),
                  onPressed: () {
                    // This will trigger the cart button animation
                    // You can replace this with actual product
                    _showSnackbar('Item added! Check cart button animation');
                  },
                ),
              ],
            ),
          ],
        ),
      ),
      floatingActionButton: AnimatedFAB(
        onPressed: () => _showSnackbar('FAB pressed!'),
        tooltip: 'Animated FAB',
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        ...children,
      ],
    );
  }

  void _showSnackbar(String message) {
    Get.snackbar(
      'Button Pressed',
      message,
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 1),
    );
  }
}
