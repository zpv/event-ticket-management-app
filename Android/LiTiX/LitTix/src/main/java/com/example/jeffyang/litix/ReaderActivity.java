package com.example.jeffyang.litix;

import android.app.Activity;
import android.content.Intent;
import android.content.res.Resources;
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


public class ReaderActivity extends AppCompatActivity {

    private Button scan_btn;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_reader);
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
                Toast.makeText(this, result.getContents(), Toast.LENGTH_LONG).show();
                sendQR(result.getContents());
            }
        }
        else {
            super.onActivityResult(requestCode, resultCode, data);
        }
    }

    // creating the method to send QR code to server
    private void sendQR(String inputString){

        HttpURLConnection client = null;

        try{
            URL url = new URL("https://ubc.design/scan-ticket");
            client = (HttpURLConnection) url.openConnection();

            client.setRequestMethod("POST");
            client.setRequestProperty("Code",inputString);
            client.setDoOutput(true);

            try{

                OutputStream os = client.getOutputStream();
                os.write(inputString.getBytes());
                os.flush();
            }
            catch(Exception error){
                //do nothing and inform the user
                Toast.makeText(this, "catch statement caught something :( (prob getOutputStream)", Toast.LENGTH_LONG).show();

            }

            
        }
        catch(MalformedURLException error) {
            Toast.makeText(this, "MalformedURLException caught something :(", Toast.LENGTH_LONG).show();
            System.out.println("URL error!");
        }
        catch(SocketTimeoutException error) {
            Toast.makeText(this, "SocketTimeoutException caught something :(", Toast.LENGTH_LONG).show();
            //Handles URL access timeout.
        }
        catch (IOException error) {
            Toast.makeText(this, "IOException caught something :(", Toast.LENGTH_LONG).show();
            //Handles input and output errors
        }

        finally {
            if(client != null) // Make sure the connection is not null.
                client.disconnect();
        }

        // to let you know we are at the end of the method
        Toast.makeText(this, "End of method", Toast.LENGTH_LONG).show();

    }

    private void writeStream(OutputStream outputPost) {
        String output = "Hello world";

        try {
            outputPost.write(output.getBytes());
            outputPost.flush();
        }
        catch (Exception error){
            Toast.makeText(this, "writeStream caught something :(", Toast.LENGTH_LONG).show();
        }
    }


}