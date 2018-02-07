//
//  ViewController.swift
//  pdf417-sample-Swift
//
//  Created by Dino on 17/12/15.
//  Copyright © 2015 Dino. All rights reserved.
//

import UIKit
import MicroBlink

class ViewController: UIViewController {
    
    var pdf417Recognizer : MBPdf417Recognizer?
    var barcodeRecognizer : MBBarcodeRecognizer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Valid until: 2018-04-29
         MBMicroblinkSDK.sharedInstance().setLicenseResource("license-pdf-swift", withExtension: "txt", inSubdirectory: "License", for: Bundle.main)
    }
    
    @IBAction func didTapScan(_ sender: AnyObject) {
         /** Create barcode recognizer */
        self.barcodeRecognizer = MBBarcodeRecognizer()
        self.barcodeRecognizer?.scanQR = true
        
        self.pdf417Recognizer = MBPdf417Recognizer()
        
        /** Create barcode settings */
        let barcodeSettings : MBBarcodeOverlaySettings = MBBarcodeOverlaySettings()
        
        /** Crate recognizer collection */
        let recognizerList : Array = [self.barcodeRecognizer!, self.pdf417Recognizer!] as! [MBRecognizer]
        let recognizerCollection : MBRecognizerCollection = MBRecognizerCollection(recognizers: recognizerList)
        
        /** Add recognizer collection to barcode settings */
        barcodeSettings.uiSettings.recognizerCollection = recognizerCollection
        
        /** Create your overlay view controller */
        let barcodeOverlayViewController : MBBarcodeOverlayViewController = MBBarcodeOverlayViewController(settings: barcodeSettings, andDelegate: self)
        
        /** Create recognizer view controller with wanted overlay view controller */
        let recognizerRunneViewController : UIViewController = MBViewControllerFactory.recognizerRunnerViewController(withOverlayViewController: barcodeOverlayViewController)
        
        /** Present the recognizer runner view controller. You can use other presentation methods as well (instead of presentViewController) */
        self.present(recognizerRunneViewController, animated: true, completion: nil)
    }
}

// MARK: MBBarcodeOverlayViewControllerDelegate
extension ViewController : MBBarcodeOverlayViewControllerDelegate {
    
    func overlayViewControllerDidFinishScanning(_ barcodeOverlayViewController: MBBarcodeOverlayViewController, state: MBRecognizerResultState) {
        
        let recognizerRunnerViewController = barcodeOverlayViewController.recognizerRunnerViewController as MBRecognizerRunnerViewController
        /** This is done on background thread */
        recognizerRunnerViewController.pauseScanning()
        
        var message: String = ""
        var title: String = ""
        
        if (self.barcodeRecognizer!.result.resultState == MBRecognizerResultState.valid) {
            title = "QR code"
            
            // Save the string representation of the code
            message = self.barcodeRecognizer!.result.stringUsingGuessedEncoding()!
        }
        else if (self.pdf417Recognizer!.result.resultState == MBRecognizerResultState.valid) {
            title = "PDF417"
            
            // Save the string representation of the code
            message = self.pdf417Recognizer!.result.stringUsingGuessedEncoding()!
        }
        
        /** Needs to be called on main thread beacuse everything prior is on background thread */
        DispatchQueue.main.async {
            // present the alert view with scanned results
            
            let alertController: UIAlertController = UIAlertController.init(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
            
            let okAction: UIAlertAction = UIAlertAction.init(title: "OK", style: UIAlertActionStyle.default,
                                                             handler: { (action) -> Void in
                                                                self.dismiss(animated: true, completion: nil)
            })
            alertController.addAction(okAction)
            barcodeOverlayViewController.present(alertController, animated: true, completion: nil)
        }
    }
    
    func overlayViewControllerDidTapClose(_ barcodeOverlayViewController: MBBarcodeOverlayViewController) {
        self.dismiss(animated: true, completion: nil)
    }
    
}


