//
//  ViewController.swift
//  Roots_02
//
//  Created by David Utt on 3/24/17.
//  Copyright © 2017 David Utt. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController,AVCaptureVideoDataOutputSampleBufferDelegate {

    //Camera Variables
    let captureSession = AVCaptureSession()
    var previewLayer:CALayer!
    var captureDevice:AVCaptureDevice!

    var takePhoto = false
    
    //Timer Variables
    weak var timer: Timer?
    var startTimer: Double = 0
    var time: Double = 0
    var count = ""
    var timerArray = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        prepareCamera()
        StartTime()
    }
    
    //Camera Functions
    func prepareCamera(){
        captureSession.sessionPreset = AVCaptureSessionPresetHigh
        
        if let availableDevices = AVCaptureDeviceDiscoverySession(deviceTypes: [.builtInWideAngleCamera,.builtInMicrophone], mediaType: AVMediaTypeVideo, position: .back).devices {
            captureDevice = availableDevices.first
            beginSession()
        }
    }
    
    func beginSession(){
        do {
            let captureDeviceInput = try AVCaptureDeviceInput(device: captureDevice)
            captureSession.addInput(captureDeviceInput)
            
        }catch {
            print(error.localizedDescription)
        }
        
        if let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession) {
            self.previewLayer = previewLayer
            self.view.layer.addSublayer(self.previewLayer)
            self.previewLayer.frame = self.view.layer.frame
            
            //set preview layer to fullscreen
            previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
            
            captureSession.startRunning()
            
            let dataOutput = AVCaptureVideoDataOutput()
            dataOutput.videoSettings = [(kCVPixelBufferPixelFormatTypeKey as NSString):NSNumber(value:kCVPixelFormatType_32BGRA)]
            
            dataOutput.alwaysDiscardsLateVideoFrames = true
            
            if captureSession.canAddOutput(dataOutput) {
                captureSession.addOutput(dataOutput)
            }
            
            captureSession.commitConfiguration()
            
            let queue = DispatchQueue(label: "Photos Taken")
            dataOutput.setSampleBufferDelegate(self, queue: queue)
        }
    }
    
    @IBAction func takePhoto(_ sender: UIBarButtonItem) {
        takePhoto = true
    }
    
    
    func captureOutput(_ captureOutput: AVCaptureOutput!, didOutputSampleBuffer sampleBuffer: CMSampleBuffer!, from connection: AVCaptureConnection!) {
    
        if takePhoto {
            takePhoto = false
            
            if let image = self.getImageFromSampleBuffer(buffer: sampleBuffer) {
                
                //call new storyboard by Storyboard ID
                let PhotoVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PhotoVC") as! PhotoViewController
                //send image data to PhotoVC
                PhotoVC.takenPhoto = image
                
                DispatchQueue.main.async {
                    //present new storyboard
                    self.present(PhotoVC, animated: true, completion:{
                        self.stopCaptureSession()
                    })
                }
            }
        }
    }
    
    func getImageFromSampleBuffer(buffer:CMSampleBuffer) -> UIImage? {
        if let pixelBuffer = CMSampleBufferGetImageBuffer(buffer) {
            let ciImage = CIImage(cvPixelBuffer: pixelBuffer)
            let context = CIContext()
            
            let imageRect = CGRect(x: 0, y: 0, width: CVPixelBufferGetWidth(pixelBuffer), height: CVPixelBufferGetHeight(pixelBuffer))
            
            if let image = context.createCGImage(ciImage, from: imageRect) {
                return UIImage(cgImage: image, scale: UIScreen.main.scale, orientation: .right)
            }
        }
        return nil
    }
    
    func stopCaptureSession(){
        self.captureSession.stopRunning()
        
        if let inputs = captureSession.inputs as? [AVCaptureDeviceInput] {
            for input in inputs {
                self.captureSession.removeInput(input)
            }
        }
    }
    
    //Timer Functions
    func StartTime(){
        startTimer = Date().timeIntervalSinceReferenceDate
        timer = Timer.scheduledTimer(timeInterval: 0.05, target: self, selector: #selector(advanceTimer(timer:)), userInfo: nil, repeats: true)
    }
    
    func advanceTimer(timer:Timer){
        //Total time since timer started, in seconds
        time = Date().timeIntervalSinceReferenceDate - startTimer
        
        //Convert the time to a string with 2 decimal places
        count = String(format: "%.2f", time)
        //countValue = Int(time)
        
        //Display the time string to a label in our view controller
        print(count)
    }
    
    func EndTime() {
        timer?.invalidate()
        print("You Spent ", count, " seconds taking that picture")
        timerArray.append(count)
        print(timerArray)
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

