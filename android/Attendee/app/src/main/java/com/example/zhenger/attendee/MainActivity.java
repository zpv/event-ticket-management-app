package com.example.zhenger.attendee;

import android.content.Intent;
import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.app.Activity;
import android.view.View;
import android.widget.Button;
import android.widget.EditText;
import android.widget.ImageView;
import android.widget.TextView;
import android.widget.Toast;


public class MainActivity extends AppCompatActivity  {
    EditText ed1;
    EditText ed2;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        Button b1 = (Button)findViewById(R.id.button);
        ed1 = (EditText)findViewById(R.id.editText);
        ed2 = (EditText)findViewById(R.id.editText2);

        b1.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                Intent i = new Intent(MainActivity.this, ScrollingMain.class);

                if(ed1.getText().toString().equals("admin") && ed2.getText().toString().equals("admin")) {
                    Toast.makeText(getApplicationContext(), "SUCCESS", Toast.LENGTH_SHORT).show();
                    MainActivity.this.startActivity(i);
                }else{
                    Toast.makeText(getApplicationContext(), "Wrong Password",Toast.LENGTH_SHORT).show();
                }
            }
        });
    }
}