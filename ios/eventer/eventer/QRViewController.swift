//
//  QRViewController.swift
//  LitTix
//
//  Created by Eric Mikulin on 2017-03-18.
//  Copyright © 2017 Eric Mikulin. All rights reserved.
//

import UIKit
import AudioToolbox
import AVFoundation
import Foundation

class QRViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {

    @IBOutlet var messageLabel: UILabel!

    // Variables related to the QR Scanner Camera and Highlight
    var captureSession:AVCaptureSession?
    var videoPreviewLayer:AVCaptureVideoPreviewLayer?
    var qrCodeFrameView:UIView?
    
    // Variables to deal the the HTTP requests
    var httpResponseCooldownBool = true
    var httpResponseBuffer: Data?
    
    // Reads the JSON in the buffer and returns the response code as an int
    func jsonBufferParseCode() -> Int{
        do {
            if let data = httpResponseBuffer,
                let json = try JSONSerialization.jsonObject(with: data) as? [String: Any] {
                    if let response = json["response"] as? Int{
                        return response
                    }
            } else {
                print("No json??")
            }
        } catch {
            print("Error deserializing JSON: \(error)")
        }
        return -1
    }

    // Reads the JSON in the buffer and returns the name as a string
    func jsonBufferParseName() -> String{
        do {
            if let data = httpResponseBuffer,
                let json = try JSONSerialization.jsonObject(with: data) as? [String: Any] {
                if let response = json["name"] as? String{
                    return response
                }
            } else {
                print("No json??")
            }
        } catch {
            print("Error deserializing JSON: \(error)")
        }
        return "Error"
    }
    
    // Function sends a POST request to the website, where the ticket is validated and in response gets the ticket details
    func postTicketToServer(ticketCode: String, completionHandler: @escaping (Data) -> ()){
        var request = URLRequest(url: URL(string: "https://ubc.design/scan-ticket")!)
        request.httpMethod = "POST"
        let postString = "code="+ticketCode
        request.httpBody = postString.data(using: .utf8)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {                                                 // check for fundamental networking error
                print("error=\(error)")
                return
            }
            
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode == 200 {
                print("Valid Response")
                self.httpResponseBuffer = data;
                completionHandler(data)
                return
            }

            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(response)")
            }

            
            let responseString = String(data: data, encoding: .utf8)
            print("responseString = \(responseString)")
        }
        task.resume()
    }
    
    // Function manages the camera and QR code scanning
    func captureOutput(_ captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [Any]!, from connection: AVCaptureConnection!) {
        // Check if the metadataObjects array is not nil and it contains at least one object.
        if metadataObjects == nil || metadataObjects.count == 0 {
            qrCodeFrameView?.frame = CGRect.zero
            messageLabel.text = "No QR code is detected"
            messageLabel.backgroundColor = UIColor.white
            httpResponseCooldownBool = true
            return
        }
        
        // Get the metadata object.
        let metadataObj = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
        
        if metadataObj.type == AVMetadataObjectTypeQRCode {
            // If the found metadata is equal to the QR code metadata then update the status label's text and set the bounds
            let barCodeObject = videoPreviewLayer?.transformedMetadataObject(for: metadataObj)
            qrCodeFrameView?.frame = barCodeObject!.bounds
            
            if metadataObj.stringValue != nil {
                
                // If the QR code contains the PREFIX: CODE and it is okay to send a new HTTP request
                if metadataObj.stringValue.hasPrefix("CODE") && httpResponseCooldownBool {
                    let ticketQRCode = String(metadataObj.stringValue.characters.dropFirst(4))
    
                    messageLabel.text = "Sending code: " + ticketQRCode
                    messageLabel.backgroundColor = UIColor.yellow

                    postTicketToServer(ticketCode: ticketQRCode) {
                        data in
                        DispatchQueue.main.async {
                            AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
                            let ticketName = self.jsonBufferParseName()
                            let ticketCode = self.jsonBufferParseCode()
                            self.validateTicket(rcode: ticketCode, rname: ticketName)
                        }
                    }
                    httpResponseCooldownBool = false
                }
            }
        }
    }
    
    // Function displays the correct color and text on the screen
    func validateTicket (rcode: Int, rname: String) {
        print(rcode)
        if rcode == 1 {
            messageLabel.text = "This ticket is valid!"
            messageLabel.backgroundColor = UIColor.green
            let alert = UIAlertController(title: "Checked in: "+rname, message: "", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Accept", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        } else if rcode == 2 {
            messageLabel.text = "This ticket is valid! Already Used"
            messageLabel.backgroundColor = UIColor.green
        } else {
            messageLabel.text = "Invalid!"
            messageLabel.backgroundColor = UIColor.red
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Get an instance of the AVCaptureDevice class to initialize a device object and provide the video as the media type parameter.
        let captureDevice = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
        
        do {
            // Get an instance of the AVCaptureDeviceInput class using the previous device object.
            let input = try AVCaptureDeviceInput(device: captureDevice)
            
            // Initialize the captureSession object.
            captureSession = AVCaptureSession()
            
            // Set the input device on the capture session.
            captureSession?.addInput(input)
            
            // Initialize a AVCaptureMetadataOutput object and set it as the output device to the capture session.
            let captureMetadataOutput = AVCaptureMetadataOutput()
            captureSession?.addOutput(captureMetadataOutput)
            
            // Set delegate and use the default dispatch queue to execute the call back
            captureMetadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            captureMetadataOutput.metadataObjectTypes = [AVMetadataObjectTypeQRCode]
            
            // Initialize the video preview layer and add it as a sublayer to the viewPreview view's layer.
            videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
            videoPreviewLayer?.videoGravity = AVLayerVideoGravityResizeAspectFill
            videoPreviewLayer?.frame = view.layer.bounds
            view.layer.addSublayer(videoPreviewLayer!)
            
            // Start video capture.
            captureSession?.startRunning()

            // Move the message label and top bar to the front
            view.bringSubview(toFront: messageLabel)
            
            // Initialize QR Code Frame to highlight the QR code
            qrCodeFrameView = UIView()
            if let qrCodeFrameView = qrCodeFrameView {
                qrCodeFrameView.layer.borderColor = UIColor.green.cgColor
                qrCodeFrameView.layer.borderWidth = 2
                view.addSubview(qrCodeFrameView)
                view.bringSubview(toFront: qrCodeFrameView)
            }
            
        } catch {
            // If any error occurs, simply print it out and don't continue any more.
            print(error)
            return
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

