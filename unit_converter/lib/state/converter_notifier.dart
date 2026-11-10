import 'package:flutter/material.dart';
import '../models/unit_category.dart';
import '../models/unit_item.dart';
import '../models/conversion_result.dart';
import '../models/history_item.dart';
import '../services/conversion_engine.dart';
import '../services/history_service.dart';

class ConverterNotifier extends ChangeNotifier {
  final List<UnitCategory> categories = UnitCategory.getAllCategories();
  final HistoryService _historyService = HistoryService();

  late UnitCategory _selectedCategory;
  late UnitItem _fromUnit;
  late UnitItem _toUnit;

  final TextEditingController inputController = TextEditingController();

  ConversionResult? _lastResult;
  String? _validationError;
  int _precision = 4;
  bool _isLiveMode = true; // Auto-calculate as user types, with manual button option
  ThemeMode _themeMode = ThemeMode.system;
  List<HistoryItem> _history = [];

  ConverterNotifier() {
    _selectedCategory = categories.first;
    _fromUnit = _selectedCategory.defaultFromUnit;
    _toUnit = _selectedCategory.defaultToUnit;
    inputController.text = '1';
    _loadHistory();
    // Run initial conversion for default state
    convert(isManual: false);
  }

  // Getters
  UnitCategory get selectedCategory => _selectedCategory;
  UnitItem get fromUnit => _fromUnit;
  UnitItem get toUnit => _toUnit;
  ConversionResult? get lastResult => _lastResult;
  String? get validationError => _validationError;
  int get precision => _precision;
  bool get isLiveMode => _isLiveMode;
  ThemeMode get themeMode => _themeMode;
  List<HistoryItem> get history => _history;

  Future<void> _loadHistory() async {
    _history = await _historyService.loadHistory();
    notifyListeners();
  }

  /// Category selector allowing the user to switch between measurement types.
  /// Resets unit dropdowns to defaults accordingly.
  void selectCategory(UnitCategory newCategory) {
    if (_selectedCategory.id == newCategory.id) return;

    _selectedCategory = newCategory;
    _fromUnit = newCategory.defaultFromUnit;
    _toUnit = newCategory.defaultToUnit;
    _validationError = null;

    if (inputController.text.isNotEmpty) {
      convert(isManual: false);
    } else {
      _lastResult = null;
      notifyListeners();
    }
  }

  /// Sets the source unit dropdown
  void setFromUnit(UnitItem unit) {
    if (_fromUnit.id == unit.id) return;
    _fromUnit = unit;
    if (_isLiveMode && inputController.text.isNotEmpty) {
      convert(isManual: false);
    } else {
      notifyListeners();
    }
  }

  /// Sets the target unit dropdown
  void setToUnit(UnitItem unit) {
    if (_toUnit.id == unit.id) return;
    _toUnit = unit;
    if (_isLiveMode && inputController.text.isNotEmpty) {
      convert(isManual: false);
    } else {
      notifyListeners();
    }
  }

  /// Swaps source and target units
  void swapUnits() {
    final temp = _fromUnit;
    _fromUnit = _toUnit;
    _toUnit = temp;

    if (_lastResult != null && inputController.text.isNotEmpty) {
      convert(isManual: false);
    } else {
      notifyListeners();
    }
  }

  /// Converts value and updates result state.
  /// Returns the result on success, or null on error.
  ConversionResult? convert({bool isManual = true}) {
    final rawText = inputController.text;

    try {
      final numericValue = ConversionEngine.validateAndParseInput(
        rawInput: rawText,
        category: _selectedCategory,
        sourceUnit: _fromUnit,
      );

      final result = ConversionEngine.convert(
        sourceValue: numericValue,
        category: _selectedCategory,
        sourceUnit: _fromUnit,
        targetUnit: _toUnit,
        precision: _precision,
      );

      _validationError = null;
      _lastResult = result;

      // Add to history only if initiated manually or valid change
      if (isManual) {
        final historyItem = HistoryItem(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          categoryId: _selectedCategory.id,
          categoryName: _selectedCategory.name,
          sourceValue: result.sourceValue,
          sourceUnitId: _fromUnit.id,
          sourceUnitName: _fromUnit.name,
          sourceUnitSymbol: _fromUnit.symbol,
          targetValue: result.targetValue,
          targetUnitId: _toUnit.id,
          targetUnitName: _toUnit.name,
          targetUnitSymbol: _toUnit.symbol,
          formula: result.formula,
          timestamp: DateTime.now(),
        );
        _historyService.addHistoryItem(historyItem);
        _history = [historyItem, ..._history];
        if (_history.length > 50) _history.removeLast();
      }

      notifyListeners();
      return result;
    } on ValidationException catch (e) {
      _validationError = e.message;
      if (isManual) {
        _lastResult = null;
      }
      notifyListeners();
      return null;
    } catch (e) {
      _validationError = 'Conversion error: ${e.toString()}';
      _lastResult = null;
      notifyListeners();
      return null;
    }
  }

  void onInputChanged(String value) {
    if (_isLiveMode) {
      if (value.trim().isEmpty) {
        _lastResult = null;
        _validationError = null;
        notifyListeners();
      } else {
        convert(isManual: false);
      }
    }
  }

  void clearInput() {
    inputController.clear();
    _lastResult = null;
    _validationError = null;
    notifyListeners();
  }

  void setSampleValue(String val) {
    inputController.text = val;
    convert(isManual: false);
  }

  void restoreHistory(HistoryItem item) {
    final cat = categories.firstWhere(
      (c) => c.id == item.categoryId,
      orElse: () => _selectedCategory,
    );
    _selectedCategory = cat;

    final from = cat.units.firstWhere(
      (u) => u.id == item.sourceUnitId,
      orElse: () => cat.defaultFromUnit,
    );
    final to = cat.units.firstWhere(
      (u) => u.id == item.targetUnitId,
      orElse: () => cat.defaultToUnit,
    );

    _fromUnit = from;
    _toUnit = to;
    inputController.text = ConversionEngine.formatNumber(item.sourceValue, precision: _precision);
    convert(isManual: false);
  }

  Future<void> clearHistory() async {
    await _historyService.clearHistory();
    _history = [];
    notifyListeners();
  }

  void setPrecision(int precision) {
    if (_precision == precision) return;
    _precision = precision;
    if (_lastResult != null) {
      convert(isManual: false);
    } else {
      notifyListeners();
    }
  }

  void toggleLiveMode(bool enabled) {
    _isLiveMode = enabled;
    notifyListeners();
  }

  void setThemeMode(ThemeMode mode) {
    _themeMode = mode;
    notifyListeners();
  }

  @override
  void dispose() {
    inputController.dispose();
    super.dispose();
  }
}

