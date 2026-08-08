package com.example.age_calculator;

import android.os.Bundle;
import android.view.View;
import android.widget.Button;
import android.widget.EditText;
import android.widget.TextView;
import android.widget.Toast;

import androidx.appcompat.app.AppCompatActivity;

import java.util.Calendar;

public class MainActivity extends AppCompatActivity {

    EditText etBirthYear;
    Button btnCalculate, btnReset;
    TextView tvResult;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        etBirthYear = findViewById(R.id.etBirthYear);
        btnCalculate = findViewById(R.id.btnCalculate);
        btnReset = findViewById(R.id.btnReset);
        tvResult = findViewById(R.id.tvResult);

        btnCalculate.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {

                String birthYearText = etBirthYear.getText().toString();

                if (birthYearText.isEmpty()) {
                    Toast.makeText(MainActivity.this, "Please enter birth year", Toast.LENGTH_SHORT).show();
                } else {

                    int birthYear = Integer.parseInt(birthYearText);
                    int currentYear = Calendar.getInstance().get(Calendar.YEAR);

                    int age = currentYear - birthYear;

                    tvResult.setText("Your Age is: " + age + " years");
                }
            }
        });

        // ✅ Reset Button Logic
        btnReset.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                etBirthYear.setText("");
                tvResult.setText("Your Age will appear here");
                Toast.makeText(MainActivity.this, "Reset Done", Toast.LENGTH_SHORT).show();
            }
        });
    }
}
