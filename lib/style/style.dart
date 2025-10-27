import 'package:flutter/material.dart';

class AppStyles {
  // Color Palette
  static const Color primaryColor = Colors.blue;
  static const Color errorColor = Colors.red;
  static const Color greyColor = Colors.grey;
  static const Color whiteColor = Colors.white;

  // Text Styles
  static const TextStyle appBarTitle = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
  );

  static const TextStyle taskTitle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
  );

  static const TextStyle taskTitleCompleted = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    decoration: TextDecoration.lineThrough,
    //line kati dibe
    color: greyColor,
  );

  static const TextStyle taskDescription = TextStyle(
    fontSize: 14,
  );

  static const TextStyle taskDescriptionCompleted = TextStyle(
    fontSize: 14,
    color: greyColor,
  );

  static const TextStyle priorityChip = TextStyle(
    color: whiteColor,
    fontSize: 12,
    fontWeight: FontWeight.w500,
  );

  static const TextStyle dateText = TextStyle(
    fontSize: 12,
    color: greyColor,
  );

  static const TextStyle emptyStateTitle = TextStyle(
    fontSize: 18,
    color: greyColor,
    fontWeight: FontWeight.w500,
  );

  static const TextStyle emptyStateSubtitle = TextStyle(
    color: greyColor,
    fontSize: 14,
  );

  static const TextStyle dialogTitle = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
  );

  static const TextStyle deleteButtonText = TextStyle(
    color: whiteColor,
    fontWeight: FontWeight.w500,
  );
}

class AppDecorations {


  // Input Decorations
  static InputDecoration searchFieldDecoration = InputDecoration(
    hintText: 'Search tasks...',
    prefixIcon: const Icon(Icons.search),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
    ),
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
  );

  static const InputDecoration taskNameDecoration = InputDecoration(
    labelText: 'Task Name',
    border: OutlineInputBorder(),
    contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
  );

  static const InputDecoration taskDescriptionDecoration = InputDecoration(
    labelText: 'Description (Optional)',
    border: OutlineInputBorder(),
    contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
  );

  static const InputDecoration priorityDropdownDecoration = InputDecoration(
    labelText: 'Priority',
    border: OutlineInputBorder(),
    contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
  );

  // Container Decorations
  static BoxDecoration priorityChipDecoration(Color color) => BoxDecoration(
    color: color,
    borderRadius: BorderRadius.circular(12),
  );
}

class AppSpacing {
  // Padding
  static const EdgeInsets screenPadding = EdgeInsets.all(16.0);
  static const EdgeInsets cardMargin = EdgeInsets.symmetric(horizontal: 16, vertical: 4);
  static const EdgeInsets priorityChipPadding = EdgeInsets.symmetric(horizontal: 8, vertical: 2);
  static const EdgeInsets dialogContentPadding = EdgeInsets.all(24);

  // Spacing
  static const double smallSpacing = 4.0;
  static const double mediumSpacing = 8.0;
  static const double largeSpacing = 16.0;
  static const double extraLargeSpacing = 24.0;
}

class AppSizes {
  // Icon Sizes
  static const double emptyStateIconSize = 64.0;
  static const double menuIconSize = 18.0;

  // Border Radius
  static const double defaultBorderRadius = 12.0;
  static const double chipBorderRadius = 12.0;

  // Text Field
  static const int descriptionMaxLines = 3;
}

class AppThemes {
  // Button Styles
  static ButtonStyle deleteButtonStyle = ElevatedButton.styleFrom(
    backgroundColor: AppStyles.errorColor,
    foregroundColor: AppStyles.whiteColor,
    elevation: 2,
  );

  static ButtonStyle primaryButtonStyle = ElevatedButton.styleFrom(
    backgroundColor: AppStyles.primaryColor,
    foregroundColor: AppStyles.whiteColor,
    elevation: 2,
  );

  // Card Themes
  static const CardTheme taskCardTheme = CardTheme(
    elevation: 2,
    margin: AppSpacing.cardMargin,
  );
}
