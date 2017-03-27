package com.example.jeffyang.littix;

import android.app.Activity;
import android.content.Intent;
import android.content.res.Resources;
import android.os.AsyncTask;
import android.support.annotation.StyleRes;
import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.view.View;
import android.widget.Button;
import android.widget.Toast;

import com.google.zxing.integration.android.IntentIntegrator;
import com.google.zxing.integration.android.IntentResult;

import java.io.*;
import java.net.*;

public class MainActivity extends AppCompatActivity {

    private Button scan_btn;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);
        scan_btn = (Button) findViewById(R.id.scan_btn);
        final Activity activity = this;
        scan_btn.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                IntentIntegrator integrator = new IntentIntegrator(activity);
                integrator.setDesiredBarcodeFormats(IntentIntegrator.QR_CODE_TYPES);
                integrator.setPrompt("Scan");
                integrator.setCameraId(0);
                integrator.setBeepEnabled(false);
                integrator.setBarcodeImageEnabled(true);
                integrator.initiateScan();
            }
        });
    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        IntentResult result = IntentIntegrator.parseActivityResult(requestCode, resultCode, data);
        if(result != null){

            if(result.getContents()==null){
                Toast.makeText(this, "You cancelled the scanning", Toast.LENGTH_LONG).show();
            }
            else{
                AsyncTaskRunner QRScan = new AsyncTaskRunner();
                QRScan.execute(result.getContents());
                Toast.makeText(this, result.getContents(), Toast.LENGTH_LONG).show();
            }

        }
        else {
            super.onActivityResult(requestCode, resultCode, data);
        }
    }











    private class AsyncTaskRunner extends AsyncTask <String, Void, String> {


        @Override
        protected String doInBackground(String... inputString) {
            HttpURLConnection client = null;

            try {
                URL url = new URL("https://littix.org/scan-ticket");
                client = (HttpURLConnection) url.openConnection();

                client.setRequestMethod("POST");
                client.setRequestProperty("code", inputString[0]);
                client.setDoOutput(true);

                try {
                    OutputStream os = client.getOutputStream();
                    os.write(inputString[0].getBytes());
                    os.flush();
                } catch (Exception error) {
                    System.out.println("Probably getOutputStream() error");
                }


            } catch (MalformedURLException error) {
                System.out.println("MalformedURLException error");
            } catch (SocketTimeoutException error) {
                System.out.println("SocketTimeoutException error");
                //Handles URL access timeout.
            } catch (IOException error) {
                System.out.println("IOException error");
                //Handles input and output errors
            } finally {
                if (client != null) // Make sure the connection is not null.
                    client.disconnect();
            }

            return "return statement";
        }


        //@Override
        protected void onPostExecute(String result) {

        }


        //@Override
        protected void onPreExecute() {

        }


        //@Override
        protected void onProgressUpdate(String... text) {

        }
    }





}

























