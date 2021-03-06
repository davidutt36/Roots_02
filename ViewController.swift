//
//  ViewController.swift
//  Roots_02
//
//  Created by David Utt on 3/24/17.
//  Copyright © 2017 David Utt. All rights reserved.
//

import UIKit
import AVFoundation

//Timer Variables
weak var timer: Timer?
var startTimer: Double = 0
var time: Double = 0
var count = ""
var timerArray = [String]()

class ViewController: UIViewController,AVCaptureVideoDataOutputSampleBufferDelegate {

    //Camera Variables
    let captureSession = AVCaptureSession()
    var previewLayer:CALayer!
    
    @IBOutlet weak var triggerButton: UIButton!
    
    
    var captureDevice:AVCaptureDevice!

    var takePhoto = false

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
   
    @IBAction func switchView(_ sender: UIButton) {
    
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
            previewLayer.zPosition = -10
            
            self.previewLayer.frame = self.view.layer.bounds
            self.view.layer.addSublayer(self.previewLayer)
            
            //set preview layer to fullscreen
            previewLayer.videoGravity = AVLayerVideoGravityResizeAspect
            
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
    
    @IBAction func takePicture(_ sender: UIButton) {
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
                return UIImage(cgImage: image, scale: UIScreen.main.nativeScale, orientation: .right)
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
    
    
    @IBAction func stopCamera(_ sender: UIBarButtonItem) {
        let PlanterVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PlanterVC") as! LauncherViewController
        self.present(PlanterVC, animated: true) { 
            timer?.invalidate()
            print("Memory Moment Ended")
        }
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

//https://developer.apple.com/reference/avfoundation/avcapturedevicetype
