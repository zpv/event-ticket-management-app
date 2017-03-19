package com.example.jeffyang.nwhackseventmanagementapp;

import android.support.v7.app.AlertDialog;
import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.util.Log;
import android.view.View;
import android.widget.Button;
import android.content.Intent;
import android.view.View;

import android.widget.TextView;
import android.widget.Toast;

import com.google.zxing.Result;

import me.dm7.barcodescanner.zxing.ZXingScannerView;



public class MainActivity extends AppCompatActivity implements View.OnClickListener, ZXingScannerView.ResultHandler {
        private ZXingScannerView mScannerView;
        Button scancode,generatecode;

        @Override
        protected void onCreate(Bundle savedInstanceState) {
            super.onCreate(savedInstanceState);
            setContentView(R.layout.activity_main);

            scancode=(Button)findViewById(R.id.button2);
            generatecode=(Button)findViewById(R.id.button);

            mScannerView = new ZXingScannerView(MainActivity.this);
            generatecode.setOnClickListener(this);
            scancode.setOnClickListener(this);
        }

        @Override
        public void onClick(View v) {

            if (v==generatecode)
            {
                Intent i=new Intent(MainActivity.this,QRCodeActivity.class);
                startActivity(i);
            }
            if(v==scancode)
            {
                ScanCode();
            }
        }

    private void ScanCode() {

        mScannerView = new ZXingScannerView(this);


        // Programmatically initialize the scanner view

        setContentView(mScannerView);
        mScannerView.setResultHandler(this);

// Register ourselves as a handler for scan results.

        mScannerView.startCamera();
    }

    @Override
    public void onPause() {
        super.onPause();
        mScannerView.stopCamera();
    }
        @Override
        public void handleResult(Result result) {
            // Do something with the result here

            Toast.makeText(MainActivity.this,"This is your Text"+result.getText(),Toast.LENGTH_SHORT);
            Log.e("handler", result.getText());

// Prints scan results

            Log.e("handler", result.getBarcodeFormat().toString());

// Prints the scan format (qrcode)

        }


        /* broken gonna try somehting else
        public void QrScanner(View view){
        mScannerView = new ZXingScannerView(this);   // Programmatically initialize the scanner view<br />
            setContentView(mScannerView);
                    mScannerView.setResultHandler(this); // Register ourselves as a handler for scan results.<br />
            mScannerView.startCamera();         // Start camera<br />
        }
    @Override
        public void onPause() {
                super.onPause();
                mScannerView.stopCamera();   // Stop camera on pause<br />
        }
    }

    private ZXingScannerView mScannerView;
    //@Override


    public void handleResult(Result rawResult) {
        // Do something with the result here</p>
        Log.e("handler", rawResult.getText()); // Prints scan results<br />
        Log.e("handler", rawResult.getBarcodeFormat().toString()); // Prints the scan format (qrcode)</p>
        // show the scanner result into dialog box.<br />
        AlertDialog.Builder builder = new AlertDialog.Builder(this);
        builder.setTitle("Scan Result");
        builder.setMessage(rawResult.getText());
        AlertDialog alert1 = builder.create();
        alert1.show();
        // If you would like to resume scanning, call this method below:<br />
        // mScannerView.resumeCameraPreview(this);<br />
    }
*/
//instructables!!!!!!
    private void goToSecondActivity() {
        Intent intent = new Intent(this, Event1Activity.class);
        startActivity(intent);
    }


}


