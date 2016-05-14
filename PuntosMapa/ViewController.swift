//
//  ViewController.swift
//  PuntosMapa
//
//  Created by Miguel Benavente Valdés on 11/05/16.
//  Copyright © 2016 Miguel Benavente Valdés. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit


class ViewController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var lblLongitud: UILabel!
    @IBOutlet weak var lblLatitud: UILabel!
    @IBOutlet weak var lblHorizontalAccurancy: UILabel!

    @IBOutlet weak var lblNteMagnetico: UILabel!
    @IBOutlet weak var lblNteGeografico: UILabel!
    
    @IBOutlet weak var mapMapa: MKMapView!/*{
        didSet {
            //var punto = CLLocationCoordinate2D()
            mapMapa.showsUserLocation = true
            //punto.latitude = 37.3247//19.52748
            //punto.longitude = -122.0245//-96.92315
            //punto.latitude = mapMapa.userLocation.coordinate.latitude//19.52748
            //punto.longitude = mapMapa.userLocation.coordinate.longitude//-96.92315

            //let noLocation = CLLocationCoordinate2D()
            let viewRegion = MKCoordinateRegionMakeWithDistance(loc, 500, 500)
            self.mapMapa.setRegion(viewRegion, animated: false)
            print("loc1: \(loc.latitude) , \(loc.longitude)")
        }
    }*/
    
    private let manejadorCLL = CLLocationManager()
    //var manejadorCLL = CLLocationManager!.self

    private var loc = CLLocationCoordinate2D()
    private var loc2 = CLLocationCoordinate2D()
    var reg : String = ""
    
    var distancia : Double = 0.0
    var distAcumulada : Double = 0.0

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //if (CLLocationManager.locationServicesEnabled()){
        manejadorCLL.delegate = self
        manejadorCLL.desiredAccuracy = kCLLocationAccuracyBest
        manejadorCLL.requestWhenInUseAuthorization()
            
        //manejadorCLL.requestLocation()
            //loc.latitude = manejadorCLL.location!.coordinate.latitude
            //loc.longitude = manejadorCLL.location!.coordinate.longitude
            //let viewRegion = MKCoordinateRegionMakeWithDistance(loc, 500, 500)
            //self.mapMapa.setRegion(viewRegion, animated: false)
        //}
        
        /*
        var punto = CLLocationCoordinate2D()
        punto.latitude = 25.421451//19.52748
        punto.longitude = -100.994301//-96.92315
        let pin = MKPointAnnotation()
        pin.title = "Saltillo"
        pin.subtitle = "Coahuila de Zaragoza"
        pin.coordinate = punto
        mapMapa.addAnnotation(pin)
        */
        

    }
    
    
   
    
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status == .AuthorizedWhenInUse{
            manejadorCLL.startUpdatingLocation()
            manejadorCLL.startUpdatingHeading()
            mapMapa.showsUserLocation = true
        }
        else{
            manejadorCLL.stopUpdatingLocation()
            manejadorCLL.stopUpdatingHeading()
            mapMapa.showsUserLocation = false
        }
    }
    
    func locationManager(manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        lblNteMagnetico.text = String(newHeading.magneticHeading)
        lblNteGeografico.text = String(newHeading.trueHeading)
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        mapMapa.showsUserLocation = true
        
        lblLatitud.text = String(manager.location!.coordinate.latitude)
        lblLongitud.text = String(manager.location!.coordinate.longitude)
        lblHorizontalAccurancy.text = String(manager.location!.horizontalAccuracy)
        
        if mapMapa.userLocation.location != nil{
            print("Entro- ",String(mapMapa.userLocation.location?.distanceFromLocation(locations.last!)))
            loc.latitude = manager.location!.coordinate.latitude
            loc.longitude = manager.location!.coordinate.longitude
            let viewRegion = MKCoordinateRegionMakeWithDistance(loc, 800, 800)
            self.mapMapa.setRegion(viewRegion, animated: false)
            print("loc: \(loc.latitude) , \(loc.longitude)")
            
            
            distancia = distancia + Double((mapMapa.userLocation.location?.distanceFromLocation(locations.last!))!)
            print("Distancia: ",String(distancia))
            
            
            //Distancia 50 metros
            if (distancia) > 50 {
                distAcumulada = distAcumulada + distancia
                //Otro punto
                var punto = CLLocationCoordinate2D()
                punto.latitude = mapMapa.userLocation.coordinate.latitude//19.52748
                punto.longitude = mapMapa.userLocation.coordinate.longitude//-96.92315
                let pin = MKPointAnnotation()
                
                let lat = String(punto.latitude.debugDescription)
                let strLat = lat.substringToIndex(lat.startIndex.advancedBy(7))
                let lon = String(punto.longitude.debugDescription)
                let strLon = lon.substringToIndex(lon.startIndex.advancedBy(10))
                let strDistanciaAcumulada = NSString(format: "%.2f", distAcumulada)
                
                pin.title = "Coordenadas: Lat: \(strLat), Lon: \(strLon)"//"Saltillo"
                pin.subtitle = "He recorrido: \(strDistanciaAcumulada) metros."
                pin.coordinate = punto
                mapMapa.addAnnotation(pin)
                print("Puso un punto")
                distancia = 0.0
            }
        }else{
            print("Es nulo la location")
        }
        
    }
    
    /*func locationManager(manager: CLLocationManager, didStartMonitoringForRegion region: CLRegion) {
        let viewRegion = MKCoordinateRegionMakeWithDistance(loc, 500, 500)
         self.mapMapa.setRegion(viewRegion, animated: false)
    }*/
    
    func locationManager(manager: CLLocationManager, didEnterRegion region: CLRegion) {
        self.reg = region.identifier
        print("Region", reg)
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        let alerta = UIAlertController(title: "Error2", message: "error \(error.code)", preferredStyle: .Alert)
        let accionOK = UIAlertAction(title: "OK", style: .Default, handler: {
            accion in
            //..nada
        })
        alerta.addAction(accionOK)
        self.presentViewController(alerta, animated: true, completion: nil)
    }
    
    /*
    func locationManagerDidResumeLocationUpdates(manager: CLLocationManager) {
        //loc.latitude = manager.location!.coordinate.latitude
        //loc.longitude = manager.location!.coordinate.longitude
        let viewRegion = MKCoordinateRegionMakeWithDistance(loc, 500, 500)
        self.mapMapa.setRegion(viewRegion, animated: false)
        print("loc2: \(loc.latitude) , \(loc.longitude)")
    }
    */

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func btnVistaNormal() {
        mapMapa.mapType = MKMapType.Standard
    }
    @IBAction func btnVistaSatelite() {
        mapMapa.mapType = MKMapType.Satellite
    }
    @IBAction func btnVistaHibrido() {
        mapMapa.mapType = MKMapType.Hybrid
    }
    
    /*func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.last
        
        let center = CLLocationCoordinate2D(latitude: location!.coordinate.latitude, longitude: location!.coordinate.longitude)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        
        self.map.setRegion(region, animated: true)
    }*/


}

