package com.example.zhenger.attendee;

import android.content.Intent;
import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.view.View;
import android.widget.AdapterView;
import android.widget.ArrayAdapter;
import android.widget.Spinner;
import android.widget.AdapterView.OnItemSelectedListener;
import android.widget.Toast;

import java.util.ArrayList;
import java.util.List;

public class ScrollingMain extends AppCompatActivity implements OnItemSelectedListener {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        Intent intent = getIntent();
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_scrolling_main);

        Spinner dropM = (Spinner) findViewById(R.id.spinner);

        dropM.setOnItemSelectedListener(this);

        List<String> categories = new ArrayList<String>();
        categories.add("Your Events");
        categories.add("Contact Organizer");
        categories.add("User Settings");

        ArrayAdapter<String> dataAdapter = new ArrayAdapter<String>(this, android.R.layout.simple_spinner_item, categories);

        dataAdapter.setDropDownViewResource(android.R.layout.simple_spinner_dropdown_item);

        dropM.setAdapter(dataAdapter);
    }

    public void onItemSelected(AdapterView<?> parent, View view, int position, long id) {
        String item = parent.getItemAtPosition(position).toString();
        Toast.makeText(parent.getContext(), "Selected: " + item, Toast.LENGTH_LONG).show();
    }

    @Override
    public void onNothingSelected(AdapterView<?> arg0) {
        //Do nothing rn
    }
}

