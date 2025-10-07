import 'dart:math';
import 'package:flutter/material.dart';

class ResponsiveUtils {
  static double screenWidth(BuildContext context) =>
      MediaQuery.of(context).size.width;

  static double screenHeight(BuildContext context) =>
      MediaQuery.of(context).size.height;

  static double screenAspectRatio(BuildContext context) =>
      MediaQuery.of(context).size.aspectRatio;

  static double devicePixelRatio(BuildContext context) =>
      MediaQuery.of(context).devicePixelRatio;

  // Breakpoints standard per mobile
  static bool isSmallScreen(BuildContext context) => screenWidth(context) < 360;

  static bool isMediumScreen(BuildContext context) =>
      screenWidth(context) >= 360 && screenWidth(context) < 414;

  static bool isLargeScreen(BuildContext context) =>
      screenWidth(context) >= 414;

  // Padding sicuri per notch e navigazione
  static EdgeInsets safeAreaPadding(BuildContext context) =>
      MediaQuery.of(context).padding;

  static double statusBarHeight(BuildContext context) =>
      MediaQuery.of(context).padding.top;

  static double bottomPadding(BuildContext context) =>
      MediaQuery.of(context).padding.bottom;

  // Dimensioni responsive basate sulla larghezza dello schermo
  static double responsiveWidth(BuildContext context, double percentage) =>
      screenWidth(context) * (percentage / 100);

  static double responsiveHeight(BuildContext context, double percentage) =>
      screenHeight(context) * (percentage / 100);

  // Font sizes responsive
  static double responsiveFontSize(BuildContext context, double baseSize) {
    final currentWidth = screenWidth(context);
    final currentHeight = screenHeight(context);

    // Calcola un fattore di scala basato sulla densità del dispositivo
    // Usiamo la diagonale per avere un scaling più bilanciato, come per i padding
    final diagonal = sqrt(
      currentWidth * currentWidth + currentHeight * currentHeight,
    );
    const referenceDiagonal =
        1000.0; // Valore di riferimento per dispositivi medi

    final scaleFactor = diagonal / referenceDiagonal;

    // Limita il scaling per evitare font troppo grandi o piccoli
    final constrainedScale = scaleFactor.clamp(0.8, 1.3);

    return baseSize * constrainedScale;
  }

  // Padding responsive
  static double responsivePadding(BuildContext context, double basePadding) {
    final currentWidth = screenWidth(context);
    final currentHeight = screenHeight(context);

    // Calcola un fattore di scala basato sulla densità del dispositivo
    // Usiamo la diagonale per avere un scaling più bilanciato
    final diagonal = sqrt(
      currentWidth * currentWidth + currentHeight * currentHeight,
    );
    const referenceDiagonal =
        1000.0; // Valore di riferimento per dispositivi medi

    final scaleFactor = diagonal / referenceDiagonal;
    final constrainedScale = scaleFactor.clamp(0.8, 1.3);

    return basePadding * constrainedScale;
  }

  // Debug info - utile per testing
  static String getDeviceInfo(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final padding = MediaQuery.of(context).padding;
    final pixelRatio = MediaQuery.of(context).devicePixelRatio;

    return '''
Screen Size: ${size.width.toStringAsFixed(1)} x ${size.height.toStringAsFixed(1)}
Pixel Ratio: ${pixelRatio.toStringAsFixed(2)}
Safe Area Top: ${padding.top.toStringAsFixed(1)}
Safe Area Bottom: ${padding.bottom.toStringAsFixed(1)}
''';
  }

  /// Calcola la distanza dal bottom per elementi fissi o padding del contenuto
  /// Se safe area bottom = 0 -> 48px dal bottom (dispositivi senza safe area)
  /// Altrimenti -> safe area bottom + 8px (dispositivi con safe area)
  ///
  /// Utile per:
  /// - Posizionamento di slider, FAB, elementi fissi
  /// - Padding bottom del contenuto per evitare sovrapposizioni
  static double getSmartBottomDistance(BuildContext context) {
    final safeAreaBottom = MediaQuery.of(context).padding.bottom;

    if (safeAreaBottom == 0.0) {
      // Dispositivo senza safe area bottom (es. Android con navigation bar nascosta)
      return 48.0;
    } else {
      // Dispositivo con safe area bottom (es. iPhone con home indicator)
      return safeAreaBottom + 8.0;
    }
  }

  // ============================================================================
  // CONVENIENCE METHODS - Conversione automatica da pixel usando le dimensioni del dispositivo
  // ============================================================================

  /// Larghezza responsive partendo da pixel
  ///
  /// Usa la larghezza reale del dispositivo corrente come base di riferimento.
  /// I pixel vengono convertiti in percentuale della larghezza del dispositivo.
  ///
  /// Esempio: responsiveWidthFromPx(context, 24) per avere 24px come percentuale della larghezza
  static double responsiveWidthFromPx(BuildContext context, double pixels) {
    final currentWidth = screenWidth(context);
    final percentage = (pixels / currentWidth) * 100;
    return responsiveWidth(context, percentage);
  }

  /// Altezza responsive partendo da pixel
  ///
  /// Usa l'altezza reale del dispositivo corrente come base di riferimento.
  /// I pixel vengono convertiti in percentuale dell'altezza del dispositivo.
  ///
  /// Esempio: responsiveHeightFromPx(context, 50) per avere 50px come percentuale dell'altezza
  static double responsiveHeightFromPx(BuildContext context, double pixels) {
    final currentHeight = screenHeight(context);
    final percentage = (pixels / currentHeight) * 100;
    return responsiveHeight(context, percentage);
  }

  /// Padding responsive partendo da pixel
  ///
  /// Usa le dimensioni reali del dispositivo per calcolare il scaling appropriato.
  /// Mantiene la logica di scaling limitato per evitare valori estremi.
  ///
  /// Esempio: responsivePaddingFromPx(context, 16) per avere 16px responsive
  static double responsivePaddingFromPx(BuildContext context, double pixels) {
    // Usa le dimensioni reali del dispositivo per calcolare lo scaling
    final currentWidth = screenWidth(context);
    final currentHeight = screenHeight(context);

    // Calcola un fattore di scala basato sulla densità del dispositivo
    // Usiamo la diagonale per avere un scaling più bilanciato
    final diagonal = sqrt(
      currentWidth * currentWidth + currentHeight * currentHeight,
    );
    const referenceDiagonal =
        1000.0; // Valore di riferimento per dispositivi medi

    final scaleFactor = diagonal / referenceDiagonal;
    final constrainedScale = scaleFactor.clamp(0.8, 1.3);

    return pixels * constrainedScale;
  }

  /// Font size responsive partendo da pixel
  ///
  /// Esempio: responsiveFontSizeFromPx(context, 24) per avere 24px responsive
  /// (Questo è identico a responsiveFontSize ma con nome più esplicito)
  static double responsiveFontSizeFromPx(BuildContext context, double pixels) {
    return responsiveFontSize(context, pixels);
  }
}

// Widget helper per facilitare l'uso
class ResponsiveWidget extends StatelessWidget {
  final Widget Function(BuildContext context, ResponsiveUtils utils) builder;

  const ResponsiveWidget({super.key, required this.builder});

  @override
  Widget build(BuildContext context) {
    return builder(context, ResponsiveUtils());
  }
}
