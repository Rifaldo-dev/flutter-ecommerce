# Animated Buttons Documentation

Koleksi widget button dengan animasi yang memberikan feedback visual yang jelas kepada user saat tombol ditekan.

## 🎯 Fitur Utama

- **Visual Feedback**: Animasi yang memberikan konfirmasi bahwa tombol sudah ditekan
- **Multiple Animation Types**: Scale, Ripple, Fade, Pulse, Rotation, Bounce
- **Loading States**: Built-in loading indicator
- **Customizable**: Warna, ukuran, border radius bisa disesuaikan
- **Specialized Buttons**: Favorite button, Cart button dengan badge
- **Performance Optimized**: Menggunakan AnimationController yang efficient

## 📱 Jenis-jenis Button

### 1. AnimatedButton (Base Widget)
Widget dasar dengan berbagai jenis animasi:

```dart
AnimatedButton(
  text: 'Click Me',
  onPressed: () => print('Pressed!'),
  animationType: AnimationType.scale, // scale, ripple, fade, bounce
  backgroundColor: Colors.blue,
  textColor: Colors.white,
)
```

### 2. AnimatedElevatedButton
Button elevated dengan animasi scale (paling umum digunakan):

```dart
AnimatedElevatedButton(
  text: 'Add to Cart',
  icon: Icon(Icons.add_shopping_cart, color: Colors.white),
  onPressed: () => addToCart(),
  isLoading: false, // untuk loading state
)
```

### 3. AnimatedOutlinedButton
Button dengan border dan animasi ripple:

```dart
AnimatedOutlinedButton(
  text: 'Cancel',
  onPressed: () => cancel(),
  borderColor: Colors.red,
  textColor: Colors.red,
)
```

### 4. AnimatedIconButton
Icon button dengan berbagai animasi:

```dart
AnimatedIconButton(
  icon: Icons.favorite,
  onPressed: () => toggleFavorite(),
  color: Colors.red,
  animationType: AnimationType.pulse,
  size: 24,
)
```

### 5. AnimatedFavoriteButton
Button khusus untuk favorite dengan animasi elastic:

```dart
AnimatedFavoriteButton(
  isFavorite: true,
  onPressed: () => toggleFavorite(),
  favoriteColor: Colors.red,
  unfavoriteColor: Colors.grey,
)
```

### 6. AnimatedCartButton
Button cart dengan badge dan animasi bounce saat item bertambah:

```dart
AnimatedCartButton(
  onPressed: () => openCart(),
  itemCount: 5, // jumlah item di cart
  badgeColor: Colors.red,
)
```

### 7. AnimatedFAB
Floating Action Button dengan animasi:

```dart
AnimatedFAB(
  onPressed: () => createNew(),
  child: Icon(Icons.add),
  tooltip: 'Add New Item',
)
```

## 🎨 Jenis Animasi

### AnimationType.scale
- Button mengecil saat ditekan
- Paling umum dan user-friendly
- Cocok untuk semua jenis button

### AnimationType.ripple
- Efek ripple dari dalam ke luar
- Bagus untuk outlined button
- Material Design style

### AnimationType.fade
- Button menjadi transparan saat ditekan
- Subtle animation
- Cocok untuk secondary actions

### AnimationType.pulse
- Button membesar lalu mengecil
- Eye-catching
- Bagus untuk notification atau alert buttons

### AnimationType.rotation
- Button berputar sedikit saat ditekan
- Unik dan playful
- Cocok untuk share atau refresh buttons

### AnimationType.bounce
- Button "memantul" saat ditekan
- Fun dan engaging
- Bagus untuk game-like interfaces

## 🔧 Customization Options

```dart
AnimatedButton(
  text: 'Custom Button',
  onPressed: () {},
  
  // Styling
  backgroundColor: Colors.purple,
  textColor: Colors.white,
  width: 200,
  height: 50,
  borderRadius: BorderRadius.circular(25),
  
  // Animation
  animationType: AnimationType.ripple,
  animationDuration: Duration(milliseconds: 200),
  
  // States
  isLoading: false,
  
  // Icon
  icon: Icon(Icons.star, color: Colors.white),
)
```

## 💡 Best Practices

### 1. Pilih Animasi yang Tepat
- **Primary Actions**: Gunakan `AnimationType.scale`
- **Secondary Actions**: Gunakan `AnimationType.fade`
- **Destructive Actions**: Gunakan `AnimationType.pulse` dengan warna merah
- **Fun Actions**: Gunakan `AnimationType.bounce`

### 2. Konsistensi
- Gunakan animasi yang sama untuk button dengan fungsi serupa
- Jangan mix terlalu banyak jenis animasi dalam satu screen

### 3. Performance
- Animasi sudah dioptimasi, tapi hindari terlalu banyak animated button dalam satu screen
- Gunakan `isLoading` state untuk mencegah multiple taps

### 4. Accessibility
- Semua button sudah support tooltip
- Warna contrast sudah diperhatikan
- Animation duration tidak terlalu lama (150-300ms)

## 🚀 Contoh Implementasi

### Product Card
```dart
// Favorite button
AnimatedFavoriteButton(
  isFavorite: product.isFavorite,
  onPressed: () => toggleFavorite(product),
)

// Add to cart button
AnimatedElevatedButton(
  text: 'Add to Cart',
  icon: Icon(Icons.add_shopping_cart),
  onPressed: () => addToCart(product),
  isLoading: isAddingToCart,
)
```

### Navigation
```dart
// Back button
AnimatedIconButton(
  icon: Icons.arrow_back,
  onPressed: () => Navigator.pop(context),
  animationType: AnimationType.scale,
)

// Menu button
AnimatedIconButton(
  icon: Icons.menu,
  onPressed: () => openDrawer(),
  animationType: AnimationType.rotation,
)
```

### Form Actions
```dart
Row(
  children: [
    Expanded(
      child: AnimatedOutlinedButton(
        text: 'Cancel',
        onPressed: () => cancel(),
        textColor: Colors.grey,
      ),
    ),
    SizedBox(width: 16),
    Expanded(
      child: AnimatedElevatedButton(
        text: 'Save',
        onPressed: () => save(),
        isLoading: isSaving,
      ),
    ),
  ],
)
```

## 🎯 Tips untuk UX yang Baik

1. **Immediate Feedback**: Animasi memberikan feedback langsung bahwa button sudah ditekan
2. **Loading States**: Gunakan `isLoading` untuk mencegah double-tap
3. **Disabled States**: Button otomatis disabled saat `onPressed` null
4. **Visual Hierarchy**: Gunakan animasi yang lebih subtle untuk secondary actions
5. **Consistency**: Gunakan pattern animasi yang sama di seluruh app

## 🔍 Troubleshooting

### Button tidak merespon
- Pastikan `onPressed` tidak null
- Check apakah ada widget lain yang menghalangi touch event

### Animasi terlihat patah-patah
- Pastikan tidak ada rebuild yang berlebihan
- Gunakan `const` constructor jika memungkinkan

### Performance issues
- Jangan gunakan terlalu banyak animated button dalam satu screen
- Dispose animation controller dengan benar (sudah otomatis)

---

Dengan menggunakan animated buttons ini, user akan mendapat feedback visual yang jelas setiap kali menekan tombol, sehingga UX menjadi lebih baik dan aplikasi terasa lebih responsive! 🎉