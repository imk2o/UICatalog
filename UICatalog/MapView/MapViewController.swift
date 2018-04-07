//
//  MapViewController.swift
//  UICatalog
//
//  Created by k2o on 2018/04/07.
//  Copyright © 2018年 Yuichi Kobayashi. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController {
    @IBOutlet weak var mapView: MKMapView!
    
    private let stations: [StationAnnotation] = [
        StationAnnotation(
            name: "押上",
            coordinate: CLLocationCoordinate2D(
                latitude: 35.710595452946052,
                longitude: 139.81331100234883
            )
        ),
        StationAnnotation(
            name: "とうきょうスカイツリー",
            coordinate: CLLocationCoordinate2D(
                latitude: 35.710531472841012,
                longitude: 139.8094596640737
            )
        ),
        StationAnnotation(
            name: "本所吾妻橋",
            coordinate: CLLocationCoordinate2D(
                latitude: 35.708649183705091,
                longitude: 139.80433243079631
            )
        )
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let regionDistance: CLLocationDistance = 1000    // meter
        let region = MKCoordinateRegionMakeWithDistance(
            CLLocationCoordinate2D(
                latitude: 35.710007730911514,
                longitude: 139.81069054070483
            ),
            regionDistance,
            regionDistance
        )
        self.mapView.setRegion(region, animated: false)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.setAnnotations(self.stations)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func setAnnotations(_ annotations: [MKAnnotation]) {
        self.mapView.removeAnnotations(self.mapView.annotations)

        annotations.map(self.mapView.addAnnotation)
        
//        self.mapView.showAnnotations(self.mapView.annotations, animated: true)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
}

extension MapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        print("Region: \(mapView.region)")
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        print(view.annotation?.title)
    }

    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
//        self.performSegue(withIdentifier: "Detail", sender: nil)
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        // 自分の現在位置を表すアノテーションは除く
        if annotation === mapView.userLocation {
            return nil
        }
        
        guard let stationAnnotation = annotation as? StationAnnotation else {
            return nil
        }
//        let styleID = placemarkAnnotation.styleID
//
        let identifier = "Station"
        let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) ?? MKAnnotationView(annotation: annotation, reuseIdentifier: identifier)
        annotationView.annotation = annotation
        annotationView.image = UIImage(named: "Control")		// FIXME
        
//        // アノテーションをタップしたら「吹き出し」を表示
//        // annotationのtitleとsubtitle、rightCalloutAccessoryViewが表示される
//        annotationView.canShowCallout = true
//        annotationView.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
//
        
        return annotationView
    }
}

class StationAnnotation: MKPointAnnotation {
    init(name: String, coordinate: CLLocationCoordinate2D) {
        super.init()
        
        self.title = name
        self.coordinate = coordinate
    }
}
