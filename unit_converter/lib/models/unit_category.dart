import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import 'unit_item.dart';

/// Represents a measurement category containing a list of supported units.
class UnitCategory {
  final String id;
  final String name;
  final IconData icon;
  final Color themeColor;
  final String baseUnitName;
  final String baseUnitSymbol;
  final List<UnitItem> units;
  final int defaultFromIndex;
  final int defaultToIndex;
  final bool allowNegative;

  const UnitCategory({
    required this.id,
    required this.name,
    required this.icon,
    required this.themeColor,
    required this.baseUnitName,
    required this.baseUnitSymbol,
    required this.units,
    this.defaultFromIndex = 0,
    this.defaultToIndex = 1,
    this.allowNegative = false,
  });

  UnitItem get defaultFromUnit => units[defaultFromIndex];
  UnitItem get defaultToUnit => units[defaultToIndex < units.length ? defaultToIndex : 0];

  /// Predefined comprehensive list of measurement categories
  static List<UnitCategory> getAllCategories() {
    return [
      // 1. LENGTH
      const UnitCategory(
        id: 'length',
        name: 'Length',
        icon: Icons.straighten_rounded,
        themeColor: AppColors.lengthColor,
        baseUnitName: 'Meter',
        baseUnitSymbol: 'm',
        defaultFromIndex: 2, // Centimeter
        defaultToIndex: 3,   // Meter
        allowNegative: false,
        units: [
          UnitItem(id: 'nm', name: 'Nanometer', symbol: 'nm', toBaseFactor: 1e-9),
          UnitItem(id: 'mm', name: 'Millimeter', symbol: 'mm', toBaseFactor: 0.001),
          UnitItem(id: 'cm', name: 'Centimeter', symbol: 'cm', toBaseFactor: 0.01),
          UnitItem(id: 'm', name: 'Meter', symbol: 'm', toBaseFactor: 1.0),
          UnitItem(id: 'km', name: 'Kilometer', symbol: 'km', toBaseFactor: 1000.0),
          UnitItem(id: 'in', name: 'Inch', symbol: 'in', toBaseFactor: 0.0254),
          UnitItem(id: 'ft', name: 'Foot', symbol: 'ft', toBaseFactor: 0.3048),
          UnitItem(id: 'yd', name: 'Yard', symbol: 'yd', toBaseFactor: 0.9144),
          UnitItem(id: 'mi', name: 'Mile', symbol: 'mi', toBaseFactor: 1609.344),
          UnitItem(id: 'nmi', name: 'Nautical Mile', symbol: 'nmi', toBaseFactor: 1852.0),
        ],
      ),

      // 2. WEIGHT & MASS
      const UnitCategory(
        id: 'weight',
        name: 'Weight',
        icon: Icons.scale_rounded,
        themeColor: AppColors.weightColor,
        baseUnitName: 'Kilogram',
        baseUnitSymbol: 'kg',
        defaultFromIndex: 2, // Gram
        defaultToIndex: 3,   // Kilogram
        allowNegative: false,
        units: [
          UnitItem(id: 'mcg', name: 'Microgram', symbol: 'µg', toBaseFactor: 1e-9),
          UnitItem(id: 'mg', name: 'Milligram', symbol: 'mg', toBaseFactor: 1e-6),
          UnitItem(id: 'g', name: 'Gram', symbol: 'g', toBaseFactor: 0.001),
          UnitItem(id: 'kg', name: 'Kilogram', symbol: 'kg', toBaseFactor: 1.0),
          UnitItem(id: 't', name: 'Metric Ton', symbol: 't', toBaseFactor: 1000.0),
          UnitItem(id: 'oz', name: 'Ounce', symbol: 'oz', toBaseFactor: 0.028349523125),
          UnitItem(id: 'lb', name: 'Pound', symbol: 'lb', toBaseFactor: 0.45359237),
          UnitItem(id: 'st', name: 'Stone', symbol: 'st', toBaseFactor: 6.35029318),
        ],
      ),

      // 3. TEMPERATURE (Non-linear)
      UnitCategory(
        id: 'temperature',
        name: 'Temperature',
        icon: Icons.thermostat_rounded,
        themeColor: AppColors.tempColor,
        baseUnitName: 'Celsius',
        baseUnitSymbol: '°C',
        defaultFromIndex: 0, // Celsius
        defaultToIndex: 1,   // Fahrenheit
        allowNegative: true,
        units: [
          // Celsius (Base)
          UnitItem(
            id: 'c',
            name: 'Celsius',
            symbol: '°C',
            customToBase: (v) => v,
            customFromBase: (b) => b,
          ),
          // Fahrenheit
          UnitItem(
            id: 'f',
            name: 'Fahrenheit',
            symbol: '°F',
            customToBase: (f) => (f - 32.0) * (5.0 / 9.0),
            customFromBase: (c) => (c * (9.0 / 5.0)) + 32.0,
          ),
          // Kelvin
          UnitItem(
            id: 'k',
            name: 'Kelvin',
            symbol: 'K',
            customToBase: (k) => k - 273.15,
            customFromBase: (c) => c + 273.15,
          ),
        ],
      ),

      // 4. VOLUME
      const UnitCategory(
        id: 'volume',
        name: 'Volume',
        icon: Icons.water_drop_rounded,
        themeColor: AppColors.volumeColor,
        baseUnitName: 'Liter',
        baseUnitSymbol: 'L',
        defaultFromIndex: 0, // Milliliter
        defaultToIndex: 1,   // Liter
        allowNegative: false,
        units: [
          UnitItem(id: 'ml', name: 'Milliliter', symbol: 'mL', toBaseFactor: 0.001),
          UnitItem(id: 'l', name: 'Liter', symbol: 'L', toBaseFactor: 1.0),
          UnitItem(id: 'm3', name: 'Cubic Meter', symbol: 'm³', toBaseFactor: 1000.0),
          UnitItem(id: 'cm3', name: 'Cubic Centimeter', symbol: 'cm³', toBaseFactor: 0.001),
          UnitItem(id: 'floz', name: 'Fluid Ounce (US)', symbol: 'fl oz', toBaseFactor: 0.0295735295625),
          UnitItem(id: 'cup', name: 'Cup (US)', symbol: 'cup', toBaseFactor: 0.2365882365),
          UnitItem(id: 'pt', name: 'Pint (US)', symbol: 'pt', toBaseFactor: 0.473176473),
          UnitItem(id: 'qt', name: 'Quart (US)', symbol: 'qt', toBaseFactor: 0.946352946),
          UnitItem(id: 'gal', name: 'Gallon (US)', symbol: 'gal', toBaseFactor: 3.785411784),
        ],
      ),

      // 5. SPEED
      const UnitCategory(
        id: 'speed',
        name: 'Speed',
        icon: Icons.speed_rounded,
        themeColor: AppColors.speedColor,
        baseUnitName: 'Meter per second',
        baseUnitSymbol: 'm/s',
        defaultFromIndex: 1, // km/h
        defaultToIndex: 2,   // mph
        allowNegative: false,
        units: [
          UnitItem(id: 'mps', name: 'Meter / second', symbol: 'm/s', toBaseFactor: 1.0),
          UnitItem(id: 'kmh', name: 'Kilometer / hour', symbol: 'km/h', toBaseFactor: 1.0 / 3.6),
          UnitItem(id: 'mph', name: 'Miles / hour', symbol: 'mph', toBaseFactor: 0.44704),
          UnitItem(id: 'knot', name: 'Knot', symbol: 'kn', toBaseFactor: 1852.0 / 3600.0),
          UnitItem(id: 'fps', name: 'Feet / second', symbol: 'ft/s', toBaseFactor: 0.3048),
        ],
      ),

      // 6. TIME
      const UnitCategory(
        id: 'time',
        name: 'Time',
        icon: Icons.timer_rounded,
        themeColor: AppColors.timeColor,
        baseUnitName: 'Second',
        baseUnitSymbol: 's',
        defaultFromIndex: 2, // Minute
        defaultToIndex: 3,   // Hour
        allowNegative: false,
        units: [
          UnitItem(id: 'ms', name: 'Millisecond', symbol: 'ms', toBaseFactor: 0.001),
          UnitItem(id: 's', name: 'Second', symbol: 's', toBaseFactor: 1.0),
          UnitItem(id: 'min', name: 'Minute', symbol: 'min', toBaseFactor: 60.0),
          UnitItem(id: 'hr', name: 'Hour', symbol: 'hr', toBaseFactor: 3600.0),
          UnitItem(id: 'day', name: 'Day', symbol: 'd', toBaseFactor: 86400.0),
          UnitItem(id: 'wk', name: 'Week', symbol: 'wk', toBaseFactor: 604800.0),
          UnitItem(id: 'yr', name: 'Year (365d)', symbol: 'yr', toBaseFactor: 31536000.0),
        ],
      ),

      // 7. AREA
      const UnitCategory(
        id: 'area',
        name: 'Area',
        icon: Icons.crop_square_rounded,
        themeColor: AppColors.areaColor,
        baseUnitName: 'Square Meter',
        baseUnitSymbol: 'm²',
        defaultFromIndex: 1, // m²
        defaultToIndex: 4,   // ft²
        allowNegative: false,
        units: [
          UnitItem(id: 'cm2', name: 'Square Centimeter', symbol: 'cm²', toBaseFactor: 0.0001),
          UnitItem(id: 'm2', name: 'Square Meter', symbol: 'm²', toBaseFactor: 1.0),
          UnitItem(id: 'km2', name: 'Square Kilometer', symbol: 'km²', toBaseFactor: 1000000.0),
          UnitItem(id: 'in2', name: 'Square Inch', symbol: 'in²', toBaseFactor: 0.00064516),
          UnitItem(id: 'ft2', name: 'Square Foot', symbol: 'ft²', toBaseFactor: 0.09290304),
          UnitItem(id: 'ac', name: 'Acre', symbol: 'ac', toBaseFactor: 4046.8564224),
          UnitItem(id: 'ha', name: 'Hectare', symbol: 'ha', toBaseFactor: 10000.0),
        ],
      ),

      // 8. DIGITAL STORAGE
      const UnitCategory(
        id: 'digital',
        name: 'Digital',
        icon: Icons.memory_rounded,
        themeColor: AppColors.digitalColor,
        baseUnitName: 'Byte',
        baseUnitSymbol: 'B',
        defaultFromIndex: 2, // MB
        defaultToIndex: 3,   // GB
        allowNegative: false,
        units: [
          UnitItem(id: 'b', name: 'Bit', symbol: 'b', toBaseFactor: 0.125),
          UnitItem(id: 'B', name: 'Byte', symbol: 'B', toBaseFactor: 1.0),
          UnitItem(id: 'KB', name: 'Kilobyte', symbol: 'KB', toBaseFactor: 1000.0),
          UnitItem(id: 'MB', name: 'Megabyte', symbol: 'MB', toBaseFactor: 1e6),
          UnitItem(id: 'GB', name: 'Gigabyte', symbol: 'GB', toBaseFactor: 1e9),
          UnitItem(id: 'TB', name: 'Terabyte', symbol: 'TB', toBaseFactor: 1e12),
          UnitItem(id: 'KiB', name: 'Kibibyte (binary)', symbol: 'KiB', toBaseFactor: 1024.0),
          UnitItem(id: 'MiB', name: 'Mebibyte (binary)', symbol: 'MiB', toBaseFactor: 1048576.0),
          UnitItem(id: 'GiB', name: 'Gibibyte (binary)', symbol: 'GiB', toBaseFactor: 1073741824.0),
        ],
      ),
    ];
  }
}
