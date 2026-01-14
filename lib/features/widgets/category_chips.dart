import 'package:flutter/material.dart';
import 'package:ecommerce_ui/utils/app_textstyles.dart';

class CategoryChips extends StatefulWidget {
  const CategoryChips({super.key});

  @override
  State<CategoryChips> createState() => _CategoryChipsState();
}

class _CategoryChipsState extends State<CategoryChips> {
  int selectedIndex = 0;
  final categories = ['All', 'Men', 'Women', 'Girls'];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 360;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: EdgeInsets.symmetric(horizontal: isSmallScreen ? 12.0 : 16.0),
      child: Row(
        children: List.generate(
          categories.length,
          (index) => Padding(
            padding: EdgeInsets.only(right: isSmallScreen ? 8.0 : 12.0),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              child: ChoiceChip(
                label: Text(
                  categories[index],
                  style: TextStyle(
                    fontSize: isSmallScreen ? 12 : 13,
                    fontWeight: selectedIndex == index
                        ? FontWeight.w600
                        : FontWeight.normal,
                    color: selectedIndex == index
                        ? Colors.white
                        : isDark
                            ? Colors.grey[300]!
                            : Colors.grey[600]!,
                  ),
                ),
                selected: selectedIndex == index,
                onSelected: (bool selected) {
                  setState(() {
                    selectedIndex = selected ? index : selectedIndex;
                  });
                },
                selectedColor: Theme.of(context).primaryColor,
                backgroundColor: isDark ? Colors.grey[800] : Colors.grey[100],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                elevation: selectedIndex == index ? 2 : 0,
                pressElevation: 0,
                padding: EdgeInsets.symmetric(
                  horizontal: isSmallScreen ? 12 : 16,
                  vertical: isSmallScreen ? 6 : 8,
                ),
                labelPadding: EdgeInsets.symmetric(
                  horizontal: isSmallScreen ? 2 : 4,
                  vertical: 1,
                ),
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                side: BorderSide(
                  color: selectedIndex == index
                      ? Colors.transparent
                      : isDark
                          ? Colors.grey[700]!
                          : Colors.grey[300]!,
                  width: 1,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
