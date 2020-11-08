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
        mapViewModel.users.bind(listener: { [unowned self] in print("+++\($0)")} )
    }
}

extension MapViewController: MKMapViewDelegate {
  // 1
  func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
    // 2

    // 3
    let identifier = "artwork"
    var view: MKMarkerAnnotationView
    // 4
    if let dequeuedView = mapView.dequeueReusableAnnotationView(
      withIdentifier: identifier) as? MKMarkerAnnotationView {
      dequeuedView.annotation = annotation
      view = dequeuedView
    } else {
      // 5
      view = MKMarkerAnnotationView(
        annotation: annotation,
        reuseIdentifier: identifier)
      view.canShowCallout = true
      view.calloutOffset = CGPoint(x: -5, y: 5)
      view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
    }
    return view
  }
}

private extension MKMapView {
  func centerToLocation(
    _ location: CLLocation,
    regionRadius: CLLocationDistance = 1000
  ) {
    let coordinateRegion = MKCoordinateRegion(
      center: location.coordinate,
      latitudinalMeters: regionRadius,
      longitudinalMeters: regionRadius)
    setRegion(coordinateRegion, animated: true)
  }
}
