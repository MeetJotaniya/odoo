import 'package:flutter/material.dart';
import 'colors.dart';

class AppTextStyles {
  static const TextStyle heading = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: AppColors.text,
  );

  static const TextStyle subheading = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: AppColors.text,
  );

  static const TextStyle body = TextStyle(
    fontSize: 16,
    color: AppColors.text,
  );

  static const TextStyle accent = TextStyle(
    fontSize: 16,
    color: AppColors.primary,
    fontWeight: FontWeight.w500,
  );

  static const TextStyle button = TextStyle(
    fontSize: 16,
    color: Colors.white,
    fontWeight: FontWeight.bold,
  );
}