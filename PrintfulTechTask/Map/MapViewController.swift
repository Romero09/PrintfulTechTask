//
//  ViewController.swift
//  PrintfulTechTask
//
//  Created by pavels.vetlugins on 07/11/2020.
//

import UIKit
import MapKit

class MapViewController: UIViewController {
    
    @IBOutlet private var mapView: MKMapView!

    private let mapViewModel = MapViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.mapView.delegate = self
        self.bind()

        let initialLocation = CLLocation(latitude: 56.9495677035, longitude: 24.1064071655)
        self.mapView.centerToLocation(initialLocation)
    }

    private func bind() {
        mapViewModel.annotations.bind(listener: { [unowned self] in self.updateAnnotations(annotations: $0) } )
    }

    private func updateAnnotations(annotations: [MapAnnotationModel]) {
        let currentAnnotations = self.mapView.annotations
        self.mapView.removeAnnotations(currentAnnotations)
        self.mapView.addAnnotations(annotations)
    }
}

// MARK: MKMapViewDelegate
extension MapViewController: MKMapViewDelegate {

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {

        let Identifier = "map-pin"
        let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: Identifier) ?? MKAnnotationView(annotation: annotation, reuseIdentifier: Identifier)

        if let annotation = annotation as? MapAnnotationModel {
            annotationView.canShowCallout = true
            annotationView.image =  UIImage(imageLiteralResourceName: "map-pin")

            if let imageData = annotation.image {
                let image = UIImage(data: imageData)
                let imgview = UIImageView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
                imgview.image = image
                annotationView.leftCalloutAccessoryView = imgview
            }
            return annotationView
        }
        return nil
    }
}

private extension MKMapView {

    func centerToLocation(_ location: CLLocation, regionRadius: CLLocationDistance = 1000) {
        let coordinateRegion = MKCoordinateRegion(
            center: location.coordinate,
            latitudinalMeters: regionRadius,
            longitudinalMeters: regionRadius)
        setRegion(coordinateRegion, animated: true)
    }
}
