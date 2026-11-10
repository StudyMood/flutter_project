# 📱 Advanced Unit Converter Application (Flutter & Android)

A production-ready, interview-grade Unit Converter application built with **Flutter (Dart)** with full **Android Studio** support. It provides conversion between units of measurement across **8 categories**, complete input validation, dynamic unit resets, conversion history, unit swapping, mathematical formula breakdowns, and Material 3 design with Dark/Light theme modes.

---

## 🎯 Feature Checklist Verification

| Requirement | Implementation Details | Status |
|---|---|:---:|
| **Input field for numeric value** | `TextField` with `TextInputType.numberWithOptions(decimal: true, signed: true)`, clear icon, sample chips | ✅ Complete |
| **Dropdown (Spinner) for Source Unit** | `UnitDropdown` displaying unit name, symbol badge, and popup list | ✅ Complete |
| **Dropdown (Spinner) for Target Unit** | `UnitDropdown` displaying unit name, symbol badge, and popup list | ✅ Complete |
| **Convert button** | Elevated `ElevatedButton` with icon, triggers calculation, haptic feedback, and history recording | ✅ Complete |
| **Result TextView with Unit Label** | `ResultCard` showing large formatted result, target unit symbol, name, and copy button | ✅ Complete |
| **Support for ≥3 categories** | **8 Categories**: Length, Weight, Temperature, Volume, Speed, Time, Area, Digital Storage | ✅ Complete |
| **Input validation (Toast message)** | Shows floating SnackBar / Toast on empty, non-numeric, negative values, and sub-absolute zero | ✅ Complete |
| **Category selector (resets dropdowns)** | Horizontal animated `CategorySelector` chips; automatically resets dropdowns to category defaults | ✅ Complete |

---

## 🚀 Advanced Interview-Grade Features

1. **Clean Architecture & Separation of Concerns**:
   - `lib/models/`: Domain models for categories, units, results, and history items.
   - `lib/services/`: Pure mathematical conversion engine (`ConversionEngine`) decoupled from UI, and persistent `HistoryService`.
   - `lib/state/`: Reactive `ChangeNotifier` state manager with zero third-party framework lock-in.
   - `lib/widgets/`: Modular, reusable components (`CategorySelector`, `UnitDropdown`, `ResultCard`, `QuickActionsBar`, etc.).
   - `lib/screens/`: Cohesive presentation screens (`ConverterScreen`, `HistoryBottomSheet`, `SettingsDialog`).

2. **Edge-Case Physical Validation**:
   - **Absolute Zero Check**: Temperature cannot drop below $0\text{ K}$, $-273.15\text{ }^\circ\text{C}$, or $-459.67\text{ }^\circ\text{F}$.
   - **Non-negative Constraints**: Length, mass, time, volume, speed, area, and digital storage cannot be negative.
   - **Comma/Dot Localization**: Automatically normalizes localized decimal commas (e.g., `12,5` $\rightarrow$ `12.5`).

3. **Step-by-Step Mathematical Explanation**:
   - Displays exact calculation formula (e.g., `(100 °C × 9/5) + 32 = 212 °F` or `1 km = 1,000 m`).

4. **1-Tap Unit Swapping (⇄)**:
   - Dedicated swap button to instantly invert From and To units and recalculate.

5. **Conversion History with Restore**:
   - Saves previous conversions with timestamp and category label.
   - Tap any past item in the bottom sheet to restore values instantly into the converter.

6. **Precision & Theme Settings**:
   - Toggle between 2, 4, or 6 decimal places.
   - Toggle between Live Conversion (as-you-type) and Manual Convert Button.
   - Material 3 Light and Dark theme modes.

7. **Copy to Clipboard**:
   - Quick copy button on the result card with visual feedback.

8. **Comprehensive Unit Test Suite**:
   - Thorough tests covering linear conversions, temperature non-linear conversions, zero/parity points, absolute zero edge cases, validation exceptions, and state transitions (`test/unit_converter_test.dart`).

---

## 📐 Supported Measurement Categories & Units

1. **Length**: Millimeter (mm), Centimeter (cm), Meter (m), Kilometer (km), Inch (in), Foot (ft), Yard (yd), Mile (mi), Nautical Mile (nmi), Nanometer (nm).
2. **Weight & Mass**: Microgram (µg), Milligram (mg), Gram (g), Kilogram (kg), Metric Ton (t), Ounce (oz), Pound (lb), Stone (st).
3. **Temperature**: Celsius (°C), Fahrenheit (°F), Kelvin (K) (with full non-linear formulas).
4. **Volume**: Milliliter (mL), Liter (L), Cubic Meter (m³), Cubic Centimeter (cm³), US Fluid Ounce (fl oz), Cup, Pint, Quart, Gallon (gal).
5. **Speed**: Meter/second (m/s), Kilometer/hour (km/h), Miles/hour (mph), Knot (kn), Foot/second (ft/s).
6. **Time**: Millisecond (ms), Second (s), Minute (min), Hour (hr), Day (d), Week (wk), Year (yr).
7. **Area**: Square Centimeter (cm²), Square Meter (m²), Square Kilometer (km²), Square Inch (in²), Square Foot (ft²), Acre (ac), Hectare (ha).
8. **Digital Storage**: Bit (b), Byte (B), Kilobyte (KB), Megabyte (MB), Gigabyte (GB), Terabyte (TB), Kibibyte (KiB), Mebibyte (MiB), Gibibyte (GiB).

---

## 🛠️ How to Run

### Prerequisites
- Flutter SDK (v3.0.0 or higher)
- Android Studio or VS Code with Flutter extension

### Steps
```bash
# 1. Navigate to the project directory
cd unit_covtr

# 2. Get packages
flutter pub get

# 3. Run unit tests
flutter test

# 4. Run application
flutter run
```

---

## 💡 Native Android (Java + XML) Reference Implementation

In case interviewers ask how the corresponding Java + XML implementation is constructed in native Android:

### 1. `res/layout/activity_main.xml` (Key Elements)
```xml
<!-- Category Spinner -->
<Spinner
    android:id="@+id/categorySpinner"
    android:layout_width="match_parent"
    android:layout_height="wrap_content" />

<!-- Numeric Input -->
<EditText
    android:id="@+id/inputValue"
    android:layout_width="match_parent"
    android:layout_height="wrap_content"
    android:inputType="numberDecimal|numberSigned"
    android:hint="Enter value" />

<!-- Source & Target Spinners -->
<Spinner
    android:id="@+id/sourceUnitSpinner"
    android:layout_width="0dp"
    android:layout_height="wrap_content"
    android:layout_weight="1" />

<ImageButton
    android:id="@+id/btnSwap"
    android:layout_width="wrap_content"
    android:layout_height="wrap_content"
    android:src="@drawable/ic_swap" />

<Spinner
    android:id="@+id/targetUnitSpinner"
    android:layout_width="0dp"
    android:layout_height="wrap_content"
    android:layout_weight="1" />

<!-- Convert Button -->
<Button
    android:id="@+id/btnConvert"
    android:layout_width="match_parent"
    android:layout_height="wrap_content"
    android:text="Convert" />

<!-- Result TextView -->
<TextView
    android:id="@+id/resultTextView"
    android:layout_width="match_parent"
    android:layout_height="wrap_content"
    android:textSize="24sp"
    android:textStyle="bold" />
```

### 2. `MainActivity.java` (Validation & Logic)
```java
btnConvert.setOnClickListener(v -> {
    String input = inputValue.getText().toString().trim();
    if (input.isEmpty()) {
        Toast.makeText(MainActivity.this, "Please enter a value", Toast.LENGTH_SHORT).show();
        return;
    }
    try {
        double value = Double.parseDouble(input);
        // Conversion logic according to selected spinners...
        resultTextView.setText(String.format(Locale.US, "%.4f %s", convertedValue, targetUnit));
    } catch (NumberFormatException e) {
        Toast.makeText(MainActivity.this, "Invalid number entered", Toast.LENGTH_SHORT).show();
    }
});
```

