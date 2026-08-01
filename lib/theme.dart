import 'package:flutter/material.dart';

/// Paleta de colores global de UnShotsito.
///
/// Los colores están diseñados para mantener una apariencia cálida,
/// juvenil y consistente, evitando blancos puros y tonos excesivamente
/// saturados.
abstract final class AppColors {
  // =========================================================
  // IDENTIDAD PRINCIPAL
  // =========================================================

  /// Naranja principal de la aplicación.
  static const Color primary = Color(0xFFD95F32);

  /// Variante más oscura para estados presionados o elementos destacados.
  static const Color primaryDark = Color(0xFFB94722);

  /// Variante clara para fondos suaves y selecciones.
  static const Color primaryLight = Color(0xFFF3B18F);

  /// Color secundario cálido.
  static const Color secondary = Color(0xFFE9A35A);

  /// Color reservado para castigos o elementos especiales.
  static const Color accent = Color(0xFF9C4F62);

  // =========================================================
  // FONDOS
  // =========================================================

  /// Fondo general de las pantallas.
  static const Color background = Color(0xFFF1E9DF);

  /// Fondo principal de tarjetas, formularios y contenedores.
  static const Color surface = Color(0xFFF8F2EB);

  /// Superficie ligeramente elevada.
  static const Color surfaceElevated = Color(0xFFFDF8F2);

  /// Fondo suave para campos y zonas secundarias.
  static const Color surfaceMuted = Color(0xFFEAE0D6);

  /// Fondo oscuro para cartas posteriores o zonas de castigo.
  static const Color surfaceDark = Color(0xFF332A27);

  // =========================================================
  // TEXTOS
  // =========================================================

  /// Texto principal.
  static const Color textPrimary = Color(0xFF292321);

  /// Texto secundario.
  static const Color textSecondary = Color(0xFF6E625D);

  /// Texto de menor prioridad.
  static const Color textMuted = Color(0xFF93857E);

  /// Texto colocado sobre el color principal.
  static const Color textOnPrimary = Color(0xFFFFF8F2);

  /// Texto colocado sobre superficies oscuras.
  static const Color textOnDark = Color(0xFFF8F0E9);

  // =========================================================
  // BORDES Y SOMBRAS
  // =========================================================

  static const Color border = Color(0xFFDCCDC1);
  static const Color borderFocused = Color(0xFFD95F32);
  static const Color divider = Color(0xFFE2D6CC);

  /// Sombra cálida que evita el negro puro.
  static const Color shadow = Color(0x332E211C);

  /// Capa oscura para modales y fondos bloqueados.
  static const Color overlay = Color(0x99251D1A);

  // =========================================================
  // ESTADOS
  // =========================================================

  static const Color success = Color(0xFF5B8A68);
  static const Color successBackground = Color(0xFFE2EEE5);

  static const Color warning = Color(0xFFC58A3B);
  static const Color warningBackground = Color(0xFFF4E8D3);

  static const Color error = Color(0xFFB95049);
  static const Color errorBackground = Color(0xFFF3DEDB);

  static const Color disabled = Color(0xFFB8ADA6);
  static const Color disabledBackground = Color(0xFFE5DDD7);

  // =========================================================
  // RETOS Y CATEGORÍAS
  // =========================================================

  /// Estos colores deben utilizarse como pequeños indicadores,
  /// íconos, etiquetas o bordes. No como fondos completos saturados.
  static const Color challenge = Color(0xFFD9783C);
  static const Color punishment = Color(0xFF9C4F62);
  static const Color group = Color(0xFF527E78);
  static const Color random = Color(0xFF79638D);
  static const Color intense = Color(0xFFAC554D);
  static const Color relaxed = Color(0xFF8A8C5A);

  // =========================================================
  // DEGRADADOS
  // =========================================================

  /// Degradado principal. Su transición es corta y discreta.
  static const LinearGradient mainGradient = LinearGradient(
    colors: [
      Color(0xFFD95F32),
      Color(0xFFE07B43),
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  /// Degradado para cartas de castigo.
  static const LinearGradient punishmentGradient = LinearGradient(
    colors: [
      Color(0xFF874356),
      Color(0xFFA65567),
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  /// Degradado oscuro para la parte posterior de tarjetas.
  static const LinearGradient darkCardGradient = LinearGradient(
    colors: [
      Color(0xFF3A302D),
      Color(0xFF2C2523),
    ],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
}

/// Medidas visuales reutilizables.
///
/// Centralizar estas constantes ayuda a mantener la misma proporción
/// en todas las pantallas.
abstract final class AppSizes {
  static const double radiusSmall = 10;
  static const double radiusMedium = 16;
  static const double radiusLarge = 24;
  static const double radiusExtraLarge = 32;

  static const double spacingExtraSmall = 4;
  static const double spacingSmall = 8;
  static const double spacingMedium = 16;
  static const double spacingLarge = 24;
  static const double spacingExtraLarge = 32;

  static const double minimumTouchSize = 48;
  static const double maximumContentWidth = 620;
}

/// Tema principal de UnShotsito.
abstract final class AppTheme {
  static ThemeData get light {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: AppColors.primary,
      primary: AppColors.primary,
      onPrimary: AppColors.textOnPrimary,
      primaryContainer: AppColors.primaryLight,
      onPrimaryContainer: AppColors.textPrimary,
      secondary: AppColors.secondary,
      onSecondary: AppColors.textPrimary,
      secondaryContainer: AppColors.warningBackground,
      onSecondaryContainer: AppColors.textPrimary,
      tertiary: AppColors.accent,
      onTertiary: AppColors.textOnPrimary,
      error: AppColors.error,
      onError: AppColors.textOnPrimary,
      surface: AppColors.surface,
      onSurface: AppColors.textPrimary,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: AppColors.background,

      // Evita el efecto visual morado predeterminado de Material.
      splashColor: AppColors.primary.withValues(alpha: 0.10),
      highlightColor: AppColors.primary.withValues(alpha: 0.06),
      focusColor: AppColors.primary.withValues(alpha: 0.12),
      hoverColor: AppColors.primary.withValues(alpha: 0.06),

      textTheme: _textTheme,
      appBarTheme: _appBarTheme,
      cardTheme: _cardTheme,
      inputDecorationTheme: _inputDecorationTheme,
      elevatedButtonTheme: _elevatedButtonTheme,
      outlinedButtonTheme: _outlinedButtonTheme,
      textButtonTheme: _textButtonTheme,
      iconButtonTheme: _iconButtonTheme,
      chipTheme: _chipTheme,
      dialogTheme: _dialogTheme,
      snackBarTheme: _snackBarTheme,
      dividerTheme: _dividerTheme,
      bottomSheetTheme: _bottomSheetTheme,
    );
  }

  static const TextTheme _textTheme = TextTheme(
    displayLarge: TextStyle(
      fontSize: 40,
      fontWeight: FontWeight.w800,
      height: 1.05,
      letterSpacing: -1.2,
      color: AppColors.textPrimary,
    ),
    displayMedium: TextStyle(
      fontSize: 34,
      fontWeight: FontWeight.w800,
      height: 1.08,
      letterSpacing: -1,
      color: AppColors.textPrimary,
    ),
    headlineLarge: TextStyle(
      fontSize: 30,
      fontWeight: FontWeight.w800,
      height: 1.12,
      letterSpacing: -0.7,
      color: AppColors.textPrimary,
    ),
    headlineMedium: TextStyle(
      fontSize: 26,
      fontWeight: FontWeight.w700,
      height: 1.16,
      letterSpacing: -0.4,
      color: AppColors.textPrimary,
    ),
    headlineSmall: TextStyle(
      fontSize: 22,
      fontWeight: FontWeight.w700,
      height: 1.20,
      color: AppColors.textPrimary,
    ),
    titleLarge: TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.w700,
      height: 1.25,
      color: AppColors.textPrimary,
    ),
    titleMedium: TextStyle(
      fontSize: 17,
      fontWeight: FontWeight.w600,
      height: 1.30,
      color: AppColors.textPrimary,
    ),
    titleSmall: TextStyle(
      fontSize: 15,
      fontWeight: FontWeight.w600,
      height: 1.30,
      color: AppColors.textPrimary,
    ),
    bodyLarge: TextStyle(
      fontSize: 17,
      fontWeight: FontWeight.w400,
      height: 1.45,
      color: AppColors.textPrimary,
    ),
    bodyMedium: TextStyle(
      fontSize: 15,
      fontWeight: FontWeight.w400,
      height: 1.45,
      color: AppColors.textSecondary,
    ),
    bodySmall: TextStyle(
      fontSize: 13,
      fontWeight: FontWeight.w400,
      height: 1.40,
      color: AppColors.textMuted,
    ),
    labelLarge: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w700,
      height: 1.20,
      letterSpacing: 0.1,
    ),
    labelMedium: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w600,
      height: 1.20,
    ),
    labelSmall: TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w600,
      height: 1.20,
    ),
  );

  static const AppBarTheme _appBarTheme = AppBarTheme(
    elevation: 0,
    scrolledUnderElevation: 0,
    centerTitle: true,
    backgroundColor: AppColors.background,
    foregroundColor: AppColors.textPrimary,
    surfaceTintColor: Colors.transparent,
    iconTheme: IconThemeData(
      color: AppColors.textPrimary,
      size: 24,
    ),
    titleTextStyle: TextStyle(
      color: AppColors.textPrimary,
      fontSize: 20,
      fontWeight: FontWeight.w700,
    ),
  );

  static const CardThemeData _cardTheme = CardThemeData(
    elevation: 0,
    color: AppColors.surface,
    surfaceTintColor: Colors.transparent,
    margin: EdgeInsets.zero,
    clipBehavior: Clip.antiAlias,
    shadowColor: AppColors.shadow,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.all(
        Radius.circular(AppSizes.radiusLarge),
      ),
      side: BorderSide(
        color: AppColors.border,
      ),
    ),
  );

  static const InputDecorationTheme _inputDecorationTheme =
      InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surfaceElevated,
        contentPadding: EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 16,
        ),
        hintStyle: TextStyle(
          color: AppColors.textMuted,
          fontSize: 15,
          fontWeight: FontWeight.w400,
        ),
        labelStyle: TextStyle(
          color: AppColors.textSecondary,
          fontSize: 15,
          fontWeight: FontWeight.w500,
        ),
        floatingLabelStyle: TextStyle(
          color: AppColors.primary,
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
        errorStyle: TextStyle(
          color: AppColors.error,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
        prefixIconColor: AppColors.textSecondary,
        suffixIconColor: AppColors.textSecondary,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(AppSizes.radiusMedium),
          ),
          borderSide: BorderSide(
            color: AppColors.border,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(AppSizes.radiusMedium),
          ),
          borderSide: BorderSide(
            color: AppColors.border,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(AppSizes.radiusMedium),
          ),
          borderSide: BorderSide(
            color: AppColors.borderFocused,
            width: 1.6,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(AppSizes.radiusMedium),
          ),
          borderSide: BorderSide(
            color: AppColors.error,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(AppSizes.radiusMedium),
          ),
          borderSide: BorderSide(
            color: AppColors.error,
            width: 1.6,
          ),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(AppSizes.radiusMedium),
          ),
          borderSide: BorderSide(
            color: AppColors.disabled,
          ),
        ),
      );

  static final ElevatedButtonThemeData _elevatedButtonTheme =
      ElevatedButtonThemeData(
        style: ButtonStyle(
          minimumSize: const WidgetStatePropertyAll(
            Size(0, AppSizes.minimumTouchSize),
          ),
          padding: const WidgetStatePropertyAll(
            EdgeInsets.symmetric(
              horizontal: 22,
              vertical: 14,
            ),
          ),
          elevation: const WidgetStatePropertyAll(0),
          backgroundColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.disabled)) {
              return AppColors.disabledBackground;
            }

            if (states.contains(WidgetState.pressed)) {
              return AppColors.primaryDark;
            }

            return AppColors.primary;
          }),
          foregroundColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.disabled)) {
              return AppColors.textMuted;
            }

            return AppColors.textOnPrimary;
          }),
          overlayColor: WidgetStatePropertyAll(
            AppColors.textOnPrimary.withValues(alpha: 0.10),
          ),
          textStyle: const WidgetStatePropertyAll(
            TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.1,
            ),
          ),
          shape: const WidgetStatePropertyAll(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(AppSizes.radiusMedium),
              ),
            ),
          ),
        ),
      );

  static final OutlinedButtonThemeData _outlinedButtonTheme =
      OutlinedButtonThemeData(
        style: ButtonStyle(
          minimumSize: const WidgetStatePropertyAll(
            Size(0, AppSizes.minimumTouchSize),
          ),
          padding: const WidgetStatePropertyAll(
            EdgeInsets.symmetric(
              horizontal: 22,
              vertical: 14,
            ),
          ),
          foregroundColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.disabled)) {
              return AppColors.disabled;
            }

            if (states.contains(WidgetState.pressed)) {
              return AppColors.primaryDark;
            }

            return AppColors.primary;
          }),
          side: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.disabled)) {
              return const BorderSide(
                color: AppColors.disabled,
              );
            }

            return const BorderSide(
              color: AppColors.primary,
              width: 1.3,
            );
          }),
          overlayColor: WidgetStatePropertyAll(
            AppColors.primary.withValues(alpha: 0.08),
          ),
          textStyle: const WidgetStatePropertyAll(
            TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
          shape: const WidgetStatePropertyAll(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(AppSizes.radiusMedium),
              ),
            ),
          ),
        ),
      );

  static final TextButtonThemeData _textButtonTheme = TextButtonThemeData(
    style: ButtonStyle(
      minimumSize: const WidgetStatePropertyAll(
        Size(0, AppSizes.minimumTouchSize),
      ),
      foregroundColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.disabled)) {
          return AppColors.disabled;
        }

        if (states.contains(WidgetState.pressed)) {
          return AppColors.primaryDark;
        }

        return AppColors.primary;
      }),
      overlayColor: WidgetStatePropertyAll(
        AppColors.primary.withValues(alpha: 0.08),
      ),
      textStyle: const WidgetStatePropertyAll(
        TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w700,
        ),
      ),
      shape: const WidgetStatePropertyAll(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(AppSizes.radiusSmall),
          ),
        ),
      ),
    ),
  );

  static final IconButtonThemeData _iconButtonTheme = IconButtonThemeData(
    style: ButtonStyle(
      minimumSize: const WidgetStatePropertyAll(
        Size.square(AppSizes.minimumTouchSize),
      ),
      foregroundColor: const WidgetStatePropertyAll(
        AppColors.textPrimary,
      ),
      overlayColor: WidgetStatePropertyAll(
        AppColors.primary.withValues(alpha: 0.08),
      ),
    ),
  );

  static const ChipThemeData _chipTheme = ChipThemeData(
    backgroundColor: AppColors.surfaceMuted,
    selectedColor: AppColors.primaryLight,
    disabledColor: AppColors.disabledBackground,
    side: BorderSide(
      color: AppColors.border,
    ),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.all(
        Radius.circular(AppSizes.radiusSmall),
      ),
    ),
    labelStyle: TextStyle(
      color: AppColors.textPrimary,
      fontSize: 14,
      fontWeight: FontWeight.w600,
    ),
    secondaryLabelStyle: TextStyle(
      color: AppColors.textPrimary,
      fontSize: 14,
      fontWeight: FontWeight.w700,
    ),
    padding: EdgeInsets.symmetric(
      horizontal: 10,
      vertical: 7,
    ),
  );

  static const DialogThemeData _dialogTheme = DialogThemeData(
    elevation: 0,
    backgroundColor: AppColors.surfaceElevated,
    surfaceTintColor: Colors.transparent,
    insetPadding: EdgeInsets.symmetric(
      horizontal: 24,
      vertical: 24,
    ),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.all(
        Radius.circular(AppSizes.radiusLarge),
      ),
      side: BorderSide(
        color: AppColors.border,
      ),
    ),
    titleTextStyle: TextStyle(
      color: AppColors.textPrimary,
      fontSize: 22,
      fontWeight: FontWeight.w700,
    ),
    contentTextStyle: TextStyle(
      color: AppColors.textSecondary,
      fontSize: 15,
      height: 1.45,
    ),
  );

  static const SnackBarThemeData _snackBarTheme = SnackBarThemeData(
    behavior: SnackBarBehavior.floating,
    elevation: 0,
    backgroundColor: AppColors.surfaceDark,
    contentTextStyle: TextStyle(
      color: AppColors.textOnDark,
      fontSize: 14,
      fontWeight: FontWeight.w500,
    ),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.all(
        Radius.circular(AppSizes.radiusMedium),
      ),
    ),
    insetPadding: EdgeInsets.fromLTRB(16, 0, 16, 16),
  );

  static const DividerThemeData _dividerTheme = DividerThemeData(
    color: AppColors.divider,
    thickness: 1,
    space: 1,
  );

  static const BottomSheetThemeData _bottomSheetTheme = BottomSheetThemeData(
    elevation: 0,
    backgroundColor: AppColors.surfaceElevated,
    surfaceTintColor: Colors.transparent,
    modalBarrierColor: AppColors.overlay,
    showDragHandle: true,
    dragHandleColor: AppColors.border,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(AppSizes.radiusLarge),
      ),
    ),
  );
}
