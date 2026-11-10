package com.interview.unitconverter;

import android.os.Bundle;
import android.view.View;
import android.widget.AdapterView;
import android.widget.ArrayAdapter;
import android.widget.Button;
import android.widget.EditText;
import android.widget.Spinner;
import android.widget.TextView;
import android.widget.Toast;

import androidx.appcompat.app.AppCompatActivity;

import com.interview.unitconverter.models.Category;
import com.interview.unitconverter.models.Unit;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.Locale;

public class MainActivity extends AppCompatActivity {

    private Spinner categorySpinner;
    private Spinner sourceUnitSpinner;
    private Spinner targetUnitSpinner;
    private EditText inputValueEditText;
    private Button btnConvert;
    private View btnSwap;
    private TextView resultHeaderTextView;
    private TextView resultValueTextView;
    private TextView formulaTextView;

    private List<Category> categories;
    private Category currentCategory;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        initViews();
        setupData();
        setupCategorySpinner();
        setupListeners();
    }

    private void initViews() {
        categorySpinner = findViewById(R.id.categorySpinner);
        sourceUnitSpinner = findViewById(R.id.sourceUnitSpinner);
        targetUnitSpinner = findViewById(R.id.targetUnitSpinner);
        inputValueEditText = findViewById(R.id.inputValueEditText);
        btnConvert = findViewById(R.id.btnConvert);
        btnSwap = findViewById(R.id.btnSwap);
        resultHeaderTextView = findViewById(R.id.resultHeaderTextView);
        resultValueTextView = findViewById(R.id.resultValueTextView);
        formulaTextView = findViewById(R.id.formulaTextView);
    }

    private void setupData() {
        categories = new ArrayList<>();

        // 1. Length
        categories.add(new Category("length", "Length", Arrays.asList(
                new Unit("mm", "Millimeter", "mm", 0.001),
                new Unit("cm", "Centimeter", "cm", 0.01),
                new Unit("m", "Meter", "m", 1.0),
                new Unit("km", "Kilometer", "km", 1000.0),
                new Unit("in", "Inch", "in", 0.0254),
                new Unit("ft", "Foot", "ft", 0.3048),
                new Unit("yd", "Yard", "yd", 0.9144),
                new Unit("mi", "Mile", "mi", 1609.344)
        ), false));

        // 2. Weight
        categories.add(new Category("weight", "Weight & Mass", Arrays.asList(
                new Unit("mg", "Milligram", "mg", 0.000001),
                new Unit("g", "Gram", "g", 0.001),
                new Unit("kg", "Kilogram", "kg", 1.0),
                new Unit("t", "Metric Ton", "t", 1000.0),
                new Unit("oz", "Ounce", "oz", 0.0283495),
                new Unit("lb", "Pound", "lb", 0.453592)
        ), false));

        // 3. Temperature
        categories.add(new Category("temp", "Temperature", Arrays.asList(
                new Unit("c", "Celsius", "°C", 1.0),
                new Unit("f", "Fahrenheit", "°F", 1.0),
                new Unit("k", "Kelvin", "K", 1.0)
        ), true));

        // 4. Volume
        categories.add(new Category("volume", "Volume", Arrays.asList(
                new Unit("ml", "Milliliter", "mL", 0.001),
                new Unit("l", "Liter", "L", 1.0),
                new Unit("m3", "Cubic Meter", "m³", 1000.0),
                new Unit("gal", "Gallon (US)", "gal", 3.78541)
        ), false));

        // 5. Speed
        categories.add(new Category("speed", "Speed", Arrays.asList(
                new Unit("mps", "Meter/second", "m/s", 1.0),
                new Unit("kmh", "Kilometer/hour", "km/h", 1.0 / 3.6),
                new Unit("mph", "Mile/hour", "mph", 0.44704),
                new Unit("kn", "Knot", "kn", 1852.0 / 3600.0)
        ), false));
    }

    private void setupCategorySpinner() {
        ArrayAdapter<Category> adapter = new ArrayAdapter<>(
                this, R.layout.spinner_item, categories);
        adapter.setDropDownViewResource(android.R.layout.simple_spinner_dropdown_item);
        categorySpinner.setAdapter(adapter);

        categorySpinner.setOnItemSelectedListener(new AdapterView.OnItemSelectedListener() {
            @Override
            public void onItemSelected(AdapterView<?> parent, View view, int position, long id) {
                currentCategory = categories.get(position);
                updateUnitSpinners(currentCategory);
            }

            @Override
            public void onNothingSelected(AdapterView<?> parent) {}
        });
    }

    private void updateUnitSpinners(Category category) {
        ArrayAdapter<Unit> unitAdapter = new ArrayAdapter<>(
                this, R.layout.spinner_item, category.getUnits());
        unitAdapter.setDropDownViewResource(android.R.layout.simple_spinner_dropdown_item);

        sourceUnitSpinner.setAdapter(unitAdapter);
        targetUnitSpinner.setAdapter(unitAdapter);

        // Reset dropdowns to defaults
        if (category.getUnits().size() > 1) {
            sourceUnitSpinner.setSelection(0);
            targetUnitSpinner.setSelection(1);
        }
    }

    private void setupListeners() {
        btnConvert.setOnClickListener(v -> performConversion());

        btnSwap.setOnClickListener(v -> {
            int fromPos = sourceUnitSpinner.getSelectedItemPosition();
            int toPos = targetUnitSpinner.getSelectedItemPosition();
            sourceUnitSpinner.setSelection(toPos);
            targetUnitSpinner.setSelection(fromPos);
            performConversion();
        });
    }

    private void performConversion() {
        String inputStr = inputValueEditText.getText().toString().trim();

        // 1. Validation: Empty Check
        if (inputStr.isEmpty()) {
            Toast.makeText(this, getString(R.string.error_empty), Toast.LENGTH_SHORT).show();
            return;
        }

        // 2. Validation: Non-Numeric Check
        double inputValue;
        try {
            inputValue = Double.parseDouble(inputStr.replace(',', '.'));
        } catch (NumberFormatException e) {
            Toast.makeText(this, getString(R.string.error_invalid), Toast.LENGTH_SHORT).show();
            return;
        }

        Unit fromUnit = (Unit) sourceUnitSpinner.getSelectedItem();
        Unit toUnit = (Unit) targetUnitSpinner.getSelectedItem();
        if (fromUnit == null || toUnit == null || currentCategory == null) return;

        // 3. Validation: Physical non-negative check
        if (!currentCategory.isAllowNegative() && inputValue < 0) {
            Toast.makeText(this, getString(R.string.error_negative), Toast.LENGTH_SHORT).show();
            return;
        }

        // 4. Validation: Absolute zero temperature
        if (currentCategory.getId().equals("temp")) {
            if (fromUnit.getId().equals("c") && inputValue < -273.15) {
                Toast.makeText(this, "Temperature cannot be below -273.15 °C (Absolute Zero)", Toast.LENGTH_LONG).show();
                return;
            } else if (fromUnit.getId().equals("f") && inputValue < -459.67) {
                Toast.makeText(this, "Temperature cannot be below -459.67 °F (Absolute Zero)", Toast.LENGTH_LONG).show();
                return;
            } else if (fromUnit.getId().equals("k") && inputValue < 0) {
                Toast.makeText(this, "Temperature cannot be below 0 K (Absolute Zero)", Toast.LENGTH_LONG).show();
                return;
            }
        }

        // Calculation
        double resultValue;
        String formulaText;

        if (currentCategory.getId().equals("temp")) {
            resultValue = convertTemperature(inputValue, fromUnit.getId(), toUnit.getId());
            formulaText = String.format(Locale.US, "Converted %s to %s", fromUnit.getName(), toUnit.getName());
        } else {
            double baseValue = inputValue * fromUnit.getToBaseFactor();
            resultValue = baseValue / toUnit.getToBaseFactor();
            double ratio = fromUnit.getToBaseFactor() / toUnit.getToBaseFactor();
            formulaText = String.format(Locale.US, "1 %s = %.4f %s", fromUnit.getSymbol(), ratio, toUnit.getSymbol());
        }

        resultHeaderTextView.setText(String.format(Locale.US, "%s %s equals", formatNumber(inputValue), fromUnit.getName()));
        resultValueTextView.setText(String.format(Locale.US, "%s %s", formatNumber(resultValue), toUnit.getSymbol()));
        formulaTextView.setText(formulaText);
    }

    private double convertTemperature(double val, String from, String to) {
        if (from.equals(to)) return val;
        // to Celsius base
        double c;
        if (from.equals("c")) c = val;
        else if (from.equals("f")) c = (val - 32.0) * (5.0 / 9.0);
        else c = val - 273.15; // from Kelvin

        // from Celsius base to target
        if (to.equals("c")) return c;
        else if (to.equals("f")) return (c * 9.0 / 5.0) + 32.0;
        else return c + 273.15; // to Kelvin
    }

    private String formatNumber(double value) {
        if (value == (long) value) {
            return String.format(Locale.US, "%d", (long) value);
        } else {
            return String.format(Locale.US, "%.4f", value).replaceAll("0*$", "").replaceAll("\\.$", "");
        }
    }
}
