package com.example.jeffyang.litix;

import android.content.Intent;
import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.view.View;
import android.widget.Button;

public class MainActivity extends AppCompatActivity {

    public Button eventButton;

    public void init() {
        eventButton = (Button)findViewById(R.id.event_btn);
        eventButton.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {

                Intent myAction = new Intent(MainActivity.this, ReaderActivity.class);
                startActivity(myAction);

            }
        });
    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        init();

    }
}
