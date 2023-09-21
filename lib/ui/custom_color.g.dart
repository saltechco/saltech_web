import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';

const tertiarybold = Color(0xFFF28F38);

CustomColors lightCustomColors = const CustomColors(
  sourceTertiarybold: Color(0xFFF28F38),
  tertiarybold: Color(0xFF924C00),
  onTertiarybold: Color(0xFFFFFFFF),
  tertiaryboldContainer: Color(0xFFFFDCC4),
  onTertiaryboldContainer: Color(0xFF2F1400),
);

CustomColors darkCustomColors = const CustomColors(
  sourceTertiarybold: Color(0xFFF28F38),
  tertiarybold: Color(0xFFFFB780),
  onTertiarybold: Color(0xFF4E2600),
  tertiaryboldContainer: Color(0xFF6F3800),
  onTertiaryboldContainer: Color(0xFFFFDCC4),
);

/// Defines a set of custom colors, each comprised of 4 complementary tones.
///
/// See also:
///   * <https://m3.material.io/styles/color/the-color-system/custom-colors>
@immutable
class CustomColors extends ThemeExtension<CustomColors> {
  const CustomColors({
    required this.sourceTertiarybold,
    required this.tertiarybold,
    required this.onTertiarybold,
    required this.tertiaryboldContainer,
    required this.onTertiaryboldContainer,
  });

  final Color? sourceTertiarybold;
  final Color? tertiarybold;
  final Color? onTertiarybold;
  final Color? tertiaryboldContainer;
  final Color? onTertiaryboldContainer;

  @override
  CustomColors copyWith({
    Color? sourceTertiarybold,
    Color? tertiarybold,
    Color? onTertiarybold,
    Color? tertiaryboldContainer,
    Color? onTertiaryboldContainer,
  }) {
    return CustomColors(
      sourceTertiarybold: sourceTertiarybold ?? this.sourceTertiarybold,
      tertiarybold: tertiarybold ?? this.tertiarybold,
      onTertiarybold: onTertiarybold ?? this.onTertiarybold,
      tertiaryboldContainer:
          tertiaryboldContainer ?? this.tertiaryboldContainer,
      onTertiaryboldContainer:
          onTertiaryboldContainer ?? this.onTertiaryboldContainer,
    );
  }

  @override
  CustomColors lerp(ThemeExtension<CustomColors>? other, double t) {
    if (other is! CustomColors) {
      return this;
    }
    return CustomColors(
      sourceTertiarybold:
          Color.lerp(sourceTertiarybold, other.sourceTertiarybold, t),
      tertiarybold: Color.lerp(tertiarybold, other.tertiarybold, t),
      onTertiarybold: Color.lerp(onTertiarybold, other.onTertiarybold, t),
      tertiaryboldContainer:
          Color.lerp(tertiaryboldContainer, other.tertiaryboldContainer, t),
      onTertiaryboldContainer:
          Color.lerp(onTertiaryboldContainer, other.onTertiaryboldContainer, t),
    );
  }

  /// Returns an instance of [CustomColors] in which the following custom
  /// colors are harmonized with [dynamic]'s [ColorScheme.primary].
  ///   * [CustomColors.sourceTertiarybold]
  ///   * [CustomColors.tertiarybold]
  ///   * [CustomColors.onTertiarybold]
  ///   * [CustomColors.tertiaryboldContainer]
  ///   * [CustomColors.onTertiaryboldContainer]
  ///
  /// See also:
  ///   * <https://m3.material.io/styles/color/the-color-system/custom-colors#harmonization>
  CustomColors harmonized(ColorScheme dynamic) {
    return copyWith(
      sourceTertiarybold: sourceTertiarybold!.harmonizeWith(dynamic.primary),
      tertiarybold: tertiarybold!.harmonizeWith(dynamic.primary),
      onTertiarybold: onTertiarybold!.harmonizeWith(dynamic.primary),
      tertiaryboldContainer:
          tertiaryboldContainer!.harmonizeWith(dynamic.primary),
      onTertiaryboldContainer:
          onTertiaryboldContainer!.harmonizeWith(dynamic.primary),
    );
  }
}
