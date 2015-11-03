//
//  ViewController.swift
//  Tarea8_GPS
//
//  Created by Carlos Alejandro Reyna González on 03/11/15.
//  Copyright © 2015 itesm. All rights reserved.
//

import UIKit
import CoreLocation //To use GPS

class ViewController: UIViewController, CLLocationManagerDelegate {

    //Outlets
    @IBOutlet weak var tf_latitud: UITextField!
    @IBOutlet weak var tf_longitud: UITextField!
    @IBOutlet weak var iv_map: UIImageView!
    
    
    //vars
    private let admGPS = CLLocationManager()
    /* -------- Delegate functions -----------------------*/
    
    //Authorization changed
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        print("Autorizando: \(status.rawValue)")

        if status == CLAuthorizationStatus.AuthorizedWhenInUse{
            admGPS.startUpdatingLocation()
        }else{
            admGPS.startUpdatingLocation()
        }
    }
    
    //Error on GPS
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print("Error en el gps \(error.description)")
    }
    
    //Locations changed
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let lastPos = locations.last!
        self.tf_latitud.text = "\(lastPos.coordinate.latitude)"
        self.tf_longitud.text = "\(lastPos.coordinate.longitude)"
        loadImage(lastPos)
    }
    
    
/* ---- Button & switch functions --- */
   
    //Button
    @IBAction func showAddress(sender: UIButton) {
        
    }
    
    //Switch
    @IBAction func switchToggle(sender: UISwitch) {
    }
    
    
/* ---------- Utility functions ----------*/
    func loadImage(position: CLLocation){
        let address = "https://maps.google.com/maps/api/staticmap?zoom=18&size=512x512&maptype=hybrid&markers=\(position.coordinate.latitude),\(position.coordinate.longitude)&sensor=true"
        // load image in async thread
        // Ejecuta el bloque en un thread separado del principal
        dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INTERACTIVE, 0),
            { () -> Void in
                let url = NSURL(string: address)!
                let datosImg = NSData(contentsOfURL: url)
                // Actualizar la GUI, debe hacerlo en el thread principal
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    if datosImg != nil {
                        self.iv_map.image = UIImage(data: datosImg!)
                    }
                })
        })
    }
    
    func setupGPS(){
        admGPS.delegate = self;
        admGPS.desiredAccuracy = kCLLocationAccuracyBest
        admGPS.requestWhenInUseAuthorization()
    }
    
    
/* --- iOS default functions --- */
    override func viewDidLoad() {
        super.viewDidLoad()
        setupGPS()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

