import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// =============================================================================
// SPACING & RADIUS (Google Classroom Style)
// =============================================================================

class AppSpacing {
  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 16.0;
  static const double lg = 24.0;
  static const double xl = 32.0;
  static const double xxl = 48.0;

  static const EdgeInsets paddingXs = EdgeInsets.all(xs);
  static const EdgeInsets paddingSm = EdgeInsets.all(sm);
  static const EdgeInsets paddingMd = EdgeInsets.all(md);
  static const EdgeInsets paddingLg = EdgeInsets.all(lg);
  static const EdgeInsets paddingXl = EdgeInsets.all(xl);

  static const EdgeInsets horizontalXs = EdgeInsets.symmetric(horizontal: xs);
  static const EdgeInsets horizontalSm = EdgeInsets.symmetric(horizontal: sm);
  static const EdgeInsets horizontalMd = EdgeInsets.symmetric(horizontal: md);
  static const EdgeInsets horizontalLg = EdgeInsets.symmetric(horizontal: lg);
  static const EdgeInsets horizontalXl = EdgeInsets.symmetric(horizontal: xl);

  static const EdgeInsets verticalXs = EdgeInsets.symmetric(vertical: xs);
  static const EdgeInsets verticalSm = EdgeInsets.symmetric(vertical: sm);
  static const EdgeInsets verticalMd = EdgeInsets.symmetric(vertical: md);
  static const EdgeInsets verticalLg = EdgeInsets.symmetric(vertical: lg);
  static const EdgeInsets verticalXl = EdgeInsets.symmetric(vertical: xl);
}

/// Google Classroom uses generous rounded corners
class AppRadius {
  static const double xs = 8.0;
  static const double sm = 12.0;
  static const double md = 16.0;
  static const double lg = 24.0;
  static const double xl = 28.0;
  static const double xxl = 32.0;
  static const double full = 100.0;

  static BorderRadius get cardRadius => BorderRadius.circular(lg);
  static BorderRadius get buttonRadius => BorderRadius.circular(xl);
  static BorderRadius get chipRadius => BorderRadius.circular(sm);
  static BorderRadius get sheetRadius => const BorderRadius.vertical(top: Radius.circular(28));
  static BorderRadius get imageRadius => BorderRadius.circular(md);
}

// =============================================================================
// TEXT STYLE EXTENSIONS
// =============================================================================

extension TextStyleContext on BuildContext {
  TextTheme get textStyles => Theme.of(this).textTheme;
}

extension TextStyleExtensions on TextStyle {
  TextStyle get bold => copyWith(fontWeight: FontWeight.bold);
  TextStyle get semiBold => copyWith(fontWeight: FontWeight.w600);
  TextStyle get medium => copyWith(fontWeight: FontWeight.w500);
  TextStyle get normal => copyWith(fontWeight: FontWeight.w400);
  TextStyle get light => copyWith(fontWeight: FontWeight.w300);
  TextStyle withColor(Color color) => copyWith(color: color);
  TextStyle withSize(double size) => copyWith(fontSize: size);
}

// =============================================================================
// GOOGLE CLASSROOM INSPIRED COLORS
// =============================================================================

/// Light mode colors inspired by Google Classroom
class LightModeColors {
  // Primary: Google Blue
  static const lightPrimary = Color(0xFF1A73E8);
  static const lightOnPrimary = Color(0xFFFFFFFF);
  static const lightPrimaryContainer = Color(0xFFD3E3FD);
  static const lightOnPrimaryContainer = Color(0xFF001D36);

  // Secondary: Teal accent
  static const lightSecondary = Color(0xFF00796B);
  static const lightOnSecondary = Color(0xFFFFFFFF);
  static const lightSecondaryContainer = Color(0xFFB2DFDB);
  static const lightOnSecondaryContainer = Color(0xFF002020);

  // Tertiary: Warm accent
  static const lightTertiary = Color(0xFFE8710A);
  static const lightOnTertiary = Color(0xFFFFFFFF);

  // Error colors
  static const lightError = Color(0xFFD93025);
  static const lightOnError = Color(0xFFFFFFFF);
  static const lightErrorContainer = Color(0xFFFCE8E6);
  static const lightOnErrorContainer = Color(0xFF5C0011);

  // Success color
  static const lightSuccess = Color(0xFF1E8E3E);

  // Surface and background: Clean whites and light grays
  static const lightSurface = Color(0xFFFFFFFF);
  static const lightOnSurface = Color(0xFF202124);
  static const lightBackground = Color(0xFFF8F9FA);
  static const lightSurfaceVariant = Color(0xFFF1F3F4);
  static const lightOnSurfaceVariant = Color(0xFF5F6368);

  // Outline
  static const lightOutline = Color(0xFFDADCE0);
  static const lightOutlineVariant = Color(0xFFE8EAED);
  static const lightShadow = Color(0xFF000000);
  static const lightInversePrimary = Color(0xFFA8C7FA);
}

/// Dark mode colors
class DarkModeColors {
  // Primary: Lighter blue for dark background
  static const darkPrimary = Color(0xFF8AB4F8);
  static const darkOnPrimary = Color(0xFF003063);
  static const darkPrimaryContainer = Color(0xFF004A8F);
  static const darkOnPrimaryContainer = Color(0xFFD3E3FD);

  // Secondary
  static const darkSecondary = Color(0xFF80CBC4);
  static const darkOnSecondary = Color(0xFF003735);
  static const darkSecondaryContainer = Color(0xFF005048);
  static const darkOnSecondaryContainer = Color(0xFFB2DFDB);

  // Tertiary
  static const darkTertiary = Color(0xFFFFB74D);
  static const darkOnTertiary = Color(0xFF4A2800);

  // Error colors
  static const darkError = Color(0xFFF28B82);
  static const darkOnError = Color(0xFF601410);
  static const darkErrorContainer = Color(0xFF8C1D18);
  static const darkOnErrorContainer = Color(0xFFFCE8E6);

  // Success
  static const darkSuccess = Color(0xFF81C995);

  // Surface and background
  static const darkSurface = Color(0xFF202124);
  static const darkOnSurface = Color(0xFFE8EAED);
  static const darkSurfaceVariant = Color(0xFF303134);
  static const darkOnSurfaceVariant = Color(0xFFC4C7C5);

  // Outline
  static const darkOutline = Color(0xFF5F6368);
  static const darkOutlineVariant = Color(0xFF3C4043);
  static const darkShadow = Color(0xFF000000);
  static const darkInversePrimary = Color(0xFF1A73E8);
}

/// Font sizes
class FontSizes {
  static const double displayLarge = 57.0;
  static const double displayMedium = 45.0;
  static const double displaySmall = 36.0;
  static const double headlineLarge = 32.0;
  static const double headlineMedium = 28.0;
  static const double headlineSmall = 24.0;
  static const double titleLarge = 22.0;
  static const double titleMedium = 16.0;
  static const double titleSmall = 14.0;
  static const double labelLarge = 14.0;
  static const double labelMedium = 12.0;
  static const double labelSmall = 11.0;
  static const double bodyLarge = 16.0;
  static const double bodyMedium = 14.0;
  static const double bodySmall = 12.0;
}

// =============================================================================
// THEMES
// =============================================================================

ThemeData get lightTheme => ThemeData(
  useMaterial3: true,
  colorScheme: ColorScheme.light(
    primary: LightModeColors.lightPrimary,
    onPrimary: LightModeColors.lightOnPrimary,
    primaryContainer: LightModeColors.lightPrimaryContainer,
    onPrimaryContainer: LightModeColors.lightOnPrimaryContainer,
    secondary: LightModeColors.lightSecondary,
    onSecondary: LightModeColors.lightOnSecondary,
    secondaryContainer: LightModeColors.lightSecondaryContainer,
    onSecondaryContainer: LightModeColors.lightOnSecondaryContainer,
    tertiary: LightModeColors.lightTertiary,
    onTertiary: LightModeColors.lightOnTertiary,
    error: LightModeColors.lightError,
    onError: LightModeColors.lightOnError,
    errorContainer: LightModeColors.lightErrorContainer,
    onErrorContainer: LightModeColors.lightOnErrorContainer,
    surface: LightModeColors.lightSurface,
    onSurface: LightModeColors.lightOnSurface,
    surfaceContainerHighest: LightModeColors.lightSurfaceVariant,
    onSurfaceVariant: LightModeColors.lightOnSurfaceVariant,
    outline: LightModeColors.lightOutline,
    outlineVariant: LightModeColors.lightOutlineVariant,
    shadow: LightModeColors.lightShadow,
    inversePrimary: LightModeColors.lightInversePrimary,
  ),
  brightness: Brightness.light,
  scaffoldBackgroundColor: LightModeColors.lightBackground,
  
  // AppBar - clean and minimal like Google Classroom
  appBarTheme: AppBarTheme(
    backgroundColor: LightModeColors.lightSurface,
    foregroundColor: LightModeColors.lightOnSurface,
    elevation: 0,
    scrolledUnderElevation: 1,
    shadowColor: LightModeColors.lightShadow.withOpacity(0.1),
    surfaceTintColor: Colors.transparent,
    centerTitle: false,
    titleTextStyle: GoogleFonts.googleSans(
      fontSize: 22,
      fontWeight: FontWeight.w400,
      color: LightModeColors.lightOnSurface,
    ),
  ),
  
  // Cards - rounded with subtle shadow
  cardTheme: CardThemeData(
    elevation: 0,
    shape: RoundedRectangleBorder(
      borderRadius: AppRadius.cardRadius,
      side: BorderSide(
        color: LightModeColors.lightOutline.withOpacity(0.5),
        width: 1,
      ),
    ),
    color: LightModeColors.lightSurface,
    surfaceTintColor: Colors.transparent,
    margin: EdgeInsets.zero,
  ),
  
  // Elevated buttons - Google style rounded
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      elevation: 0,
      backgroundColor: LightModeColors.lightPrimary,
      foregroundColor: LightModeColors.lightOnPrimary,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      shape: RoundedRectangleBorder(
        borderRadius: AppRadius.buttonRadius,
      ),
      textStyle: GoogleFonts.googleSans(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.1,
      ),
    ),
  ),
  
  // Filled buttons
  filledButtonTheme: FilledButtonThemeData(
    style: FilledButton.styleFrom(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      shape: RoundedRectangleBorder(
        borderRadius: AppRadius.buttonRadius,
      ),
      textStyle: GoogleFonts.googleSans(
        fontSize: 14,
        fontWeight: FontWeight.w500,
      ),
    ),
  ),
  
  // Outlined buttons
  outlinedButtonTheme: OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      shape: RoundedRectangleBorder(
        borderRadius: AppRadius.buttonRadius,
      ),
      side: const BorderSide(color: LightModeColors.lightOutline),
      textStyle: GoogleFonts.googleSans(
        fontSize: 14,
        fontWeight: FontWeight.w500,
      ),
    ),
  ),
  
  // Text buttons
  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: AppRadius.buttonRadius,
      ),
      textStyle: GoogleFonts.googleSans(
        fontSize: 14,
        fontWeight: FontWeight.w500,
      ),
    ),
  ),
  
  // FAB - Google style
  floatingActionButtonTheme: FloatingActionButtonThemeData(
    backgroundColor: LightModeColors.lightPrimary,
    foregroundColor: LightModeColors.lightOnPrimary,
    elevation: 3,
    highlightElevation: 6,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16),
    ),
  ),
  
  // Chips - rounded
  chipTheme: ChipThemeData(
    backgroundColor: LightModeColors.lightSurfaceVariant,
    selectedColor: LightModeColors.lightPrimaryContainer,
    labelStyle: GoogleFonts.googleSans(fontSize: 14),
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    shape: RoundedRectangleBorder(
      borderRadius: AppRadius.chipRadius,
    ),
    side: BorderSide.none,
  ),
  
  // Input decoration - rounded
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: LightModeColors.lightSurfaceVariant,
    border: OutlineInputBorder(
      borderRadius: AppRadius.buttonRadius,
      borderSide: BorderSide.none,
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: AppRadius.buttonRadius,
      borderSide: BorderSide.none,
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: AppRadius.buttonRadius,
      borderSide: const BorderSide(color: LightModeColors.lightPrimary, width: 2),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: AppRadius.buttonRadius,
      borderSide: const BorderSide(color: LightModeColors.lightError),
    ),
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    hintStyle: GoogleFonts.googleSans(
      color: LightModeColors.lightOnSurfaceVariant,
    ),
  ),
  
  // Bottom sheet - rounded top
  bottomSheetTheme: const BottomSheetThemeData(
    backgroundColor: LightModeColors.lightSurface,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
    ),
    showDragHandle: true,
    dragHandleColor: LightModeColors.lightOutline,
  ),
  
  // Dialog - rounded
  dialogTheme: DialogThemeData(
    backgroundColor: LightModeColors.lightSurface,
    elevation: 6,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(28),
    ),
  ),
  
  // Snackbar
  snackBarTheme: SnackBarThemeData(
    backgroundColor: LightModeColors.lightOnSurface,
    contentTextStyle: GoogleFonts.googleSans(color: LightModeColors.lightSurface),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8),
    ),
    behavior: SnackBarBehavior.floating,
  ),
  
  // Navigation bar
  navigationBarTheme: NavigationBarThemeData(
    backgroundColor: LightModeColors.lightSurface,
    indicatorColor: LightModeColors.lightPrimaryContainer,
    labelTextStyle: WidgetStateProperty.all(
      GoogleFonts.googleSans(fontSize: 12, fontWeight: FontWeight.w500),
    ),
    elevation: 0,
    surfaceTintColor: Colors.transparent,
  ),
  
  // Divider
  dividerTheme: const DividerThemeData(
    color: LightModeColors.lightOutlineVariant,
    thickness: 1,
    space: 1,
  ),
  
  // List tile
  listTileTheme: ListTileThemeData(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
  ),
  
  textTheme: _buildTextTheme(Brightness.light),
);

ThemeData get darkTheme => ThemeData(
  useMaterial3: true,
  colorScheme: ColorScheme.dark(
    primary: DarkModeColors.darkPrimary,
    onPrimary: DarkModeColors.darkOnPrimary,
    primaryContainer: DarkModeColors.darkPrimaryContainer,
    onPrimaryContainer: DarkModeColors.darkOnPrimaryContainer,
    secondary: DarkModeColors.darkSecondary,
    onSecondary: DarkModeColors.darkOnSecondary,
    secondaryContainer: DarkModeColors.darkSecondaryContainer,
    onSecondaryContainer: DarkModeColors.darkOnSecondaryContainer,
    tertiary: DarkModeColors.darkTertiary,
    onTertiary: DarkModeColors.darkOnTertiary,
    error: DarkModeColors.darkError,
    onError: DarkModeColors.darkOnError,
    errorContainer: DarkModeColors.darkErrorContainer,
    onErrorContainer: DarkModeColors.darkOnErrorContainer,
    surface: DarkModeColors.darkSurface,
    onSurface: DarkModeColors.darkOnSurface,
    surfaceContainerHighest: DarkModeColors.darkSurfaceVariant,
    onSurfaceVariant: DarkModeColors.darkOnSurfaceVariant,
    outline: DarkModeColors.darkOutline,
    outlineVariant: DarkModeColors.darkOutlineVariant,
    shadow: DarkModeColors.darkShadow,
    inversePrimary: DarkModeColors.darkInversePrimary,
  ),
  brightness: Brightness.dark,
  scaffoldBackgroundColor: DarkModeColors.darkSurface,
  
  appBarTheme: AppBarTheme(
    backgroundColor: DarkModeColors.darkSurface,
    foregroundColor: DarkModeColors.darkOnSurface,
    elevation: 0,
    scrolledUnderElevation: 1,
    shadowColor: DarkModeColors.darkShadow.withOpacity(0.3),
    surfaceTintColor: Colors.transparent,
    centerTitle: false,
    titleTextStyle: GoogleFonts.googleSans(
      fontSize: 22,
      fontWeight: FontWeight.w400,
      color: DarkModeColors.darkOnSurface,
    ),
  ),
  
  cardTheme: CardThemeData(
    elevation: 0,
    shape: RoundedRectangleBorder(
      borderRadius: AppRadius.cardRadius,
      side: BorderSide(
        color: DarkModeColors.darkOutlineVariant,
        width: 1,
      ),
    ),
    color: DarkModeColors.darkSurfaceVariant,
    surfaceTintColor: Colors.transparent,
    margin: EdgeInsets.zero,
  ),
  
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      elevation: 0,
      backgroundColor: DarkModeColors.darkPrimary,
      foregroundColor: DarkModeColors.darkOnPrimary,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      shape: RoundedRectangleBorder(
        borderRadius: AppRadius.buttonRadius,
      ),
      textStyle: GoogleFonts.googleSans(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.1,
      ),
    ),
  ),
  
  filledButtonTheme: FilledButtonThemeData(
    style: FilledButton.styleFrom(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      shape: RoundedRectangleBorder(
        borderRadius: AppRadius.buttonRadius,
      ),
      textStyle: GoogleFonts.googleSans(
        fontSize: 14,
        fontWeight: FontWeight.w500,
      ),
    ),
  ),
  
  outlinedButtonTheme: OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      shape: RoundedRectangleBorder(
        borderRadius: AppRadius.buttonRadius,
      ),
      side: const BorderSide(color: DarkModeColors.darkOutline),
      textStyle: GoogleFonts.googleSans(
        fontSize: 14,
        fontWeight: FontWeight.w500,
      ),
    ),
  ),
  
  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: AppRadius.buttonRadius,
      ),
      textStyle: GoogleFonts.googleSans(
        fontSize: 14,
        fontWeight: FontWeight.w500,
      ),
    ),
  ),
  
  floatingActionButtonTheme: FloatingActionButtonThemeData(
    backgroundColor: DarkModeColors.darkPrimaryContainer,
    foregroundColor: DarkModeColors.darkOnPrimaryContainer,
    elevation: 3,
    highlightElevation: 6,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16),
    ),
  ),
  
  chipTheme: ChipThemeData(
    backgroundColor: DarkModeColors.darkSurfaceVariant,
    selectedColor: DarkModeColors.darkPrimaryContainer,
    labelStyle: GoogleFonts.googleSans(fontSize: 14),
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    shape: RoundedRectangleBorder(
      borderRadius: AppRadius.chipRadius,
    ),
    side: BorderSide.none,
  ),
  
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: DarkModeColors.darkSurfaceVariant,
    border: OutlineInputBorder(
      borderRadius: AppRadius.buttonRadius,
      borderSide: BorderSide.none,
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: AppRadius.buttonRadius,
      borderSide: BorderSide.none,
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: AppRadius.buttonRadius,
      borderSide: const BorderSide(color: DarkModeColors.darkPrimary, width: 2),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: AppRadius.buttonRadius,
      borderSide: const BorderSide(color: DarkModeColors.darkError),
    ),
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    hintStyle: GoogleFonts.googleSans(
      color: DarkModeColors.darkOnSurfaceVariant,
    ),
  ),
  
  bottomSheetTheme: const BottomSheetThemeData(
    backgroundColor: DarkModeColors.darkSurfaceVariant,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
    ),
    showDragHandle: true,
    dragHandleColor: DarkModeColors.darkOutline,
  ),
  
  dialogTheme: DialogThemeData(
    backgroundColor: DarkModeColors.darkSurfaceVariant,
    elevation: 6,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(28),
    ),
  ),
  
  snackBarTheme: SnackBarThemeData(
    backgroundColor: DarkModeColors.darkOnSurface,
    contentTextStyle: GoogleFonts.googleSans(color: DarkModeColors.darkSurface),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8),
    ),
    behavior: SnackBarBehavior.floating,
  ),
  
  navigationBarTheme: NavigationBarThemeData(
    backgroundColor: DarkModeColors.darkSurface,
    indicatorColor: DarkModeColors.darkPrimaryContainer,
    labelTextStyle: WidgetStateProperty.all(
      GoogleFonts.googleSans(fontSize: 12, fontWeight: FontWeight.w500),
    ),
    elevation: 0,
    surfaceTintColor: Colors.transparent,
  ),
  
  dividerTheme: const DividerThemeData(
    color: DarkModeColors.darkOutlineVariant,
    thickness: 1,
    space: 1,
  ),
  
  listTileTheme: ListTileThemeData(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
  ),
  
  textTheme: _buildTextTheme(Brightness.dark),
);

/// Build text theme using Google Sans (Product Sans alternative)
TextTheme _buildTextTheme(Brightness brightness) {
  final color = brightness == Brightness.light 
      ? LightModeColors.lightOnSurface 
      : DarkModeColors.darkOnSurface;
  
  return TextTheme(
    displayLarge: GoogleFonts.googleSans(
      fontSize: FontSizes.displayLarge,
      fontWeight: FontWeight.w400,
      letterSpacing: -0.25,
      color: color,
    ),
    displayMedium: GoogleFonts.googleSans(
      fontSize: FontSizes.displayMedium,
      fontWeight: FontWeight.w400,
      color: color,
    ),
    displaySmall: GoogleFonts.googleSans(
      fontSize: FontSizes.displaySmall,
      fontWeight: FontWeight.w400,
      color: color,
    ),
    headlineLarge: GoogleFonts.googleSans(
      fontSize: FontSizes.headlineLarge,
      fontWeight: FontWeight.w400,
      letterSpacing: -0.5,
      color: color,
    ),
    headlineMedium: GoogleFonts.googleSans(
      fontSize: FontSizes.headlineMedium,
      fontWeight: FontWeight.w400,
      color: color,
    ),
    headlineSmall: GoogleFonts.googleSans(
      fontSize: FontSizes.headlineSmall,
      fontWeight: FontWeight.w400,
      color: color,
    ),
    titleLarge: GoogleFonts.googleSans(
      fontSize: FontSizes.titleLarge,
      fontWeight: FontWeight.w500,
      color: color,
    ),
    titleMedium: GoogleFonts.googleSans(
      fontSize: FontSizes.titleMedium,
      fontWeight: FontWeight.w500,
      color: color,
    ),
    titleSmall: GoogleFonts.googleSans(
      fontSize: FontSizes.titleSmall,
      fontWeight: FontWeight.w500,
      color: color,
    ),
    labelLarge: GoogleFonts.googleSans(
      fontSize: FontSizes.labelLarge,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.1,
      color: color,
    ),
    labelMedium: GoogleFonts.googleSans(
      fontSize: FontSizes.labelMedium,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.5,
      color: color,
    ),
    labelSmall: GoogleFonts.googleSans(
      fontSize: FontSizes.labelSmall,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.5,
      color: color,
    ),
    bodyLarge: GoogleFonts.roboto(
      fontSize: FontSizes.bodyLarge,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.15,
      color: color,
    ),
    bodyMedium: GoogleFonts.roboto(
      fontSize: FontSizes.bodyMedium,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.25,
      color: color,
    ),
    bodySmall: GoogleFonts.roboto(
      fontSize: FontSizes.bodySmall,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.4,
      color: color,
    ),
  );
}
