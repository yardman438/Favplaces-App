//
//  MapScreenViewController.swift
//  favplaces
//
//  Created by Serhii Dvornyk on 08.06.2022.
//

import UIKit
import MapKit
import CoreLocation

class MapScreenViewController: UIViewController {
    
    private let mapManager = MapManager()
    
    private let viewModel: MapScreenViewModel
    private let mapScreenView = MapScreenView()
        
    private let annotationIdentifier = "annotationIdentifier"
    var incomeIdentifier = ""
    var previousLocation: CLLocation? {
        didSet {
            mapManager.startTrackingUserLocation(mapView: mapScreenView.mapView, location: previousLocation) { [weak self] (currentLocation) in
                
                guard let self = self else { return }
                
                self.previousLocation = currentLocation
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    self.mapManager.showUserLocation(mapView: self.mapScreenView.mapView)
                }
            }
        }
    }
    
    init(viewModel: MapScreenViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = mapScreenView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupInterface()
        setupMapView()
    }
    
    @objc private func cancelButtonTapped() {
        self.incomeIdentifier = ""
        self.dismiss(animated: true)
    }
    
    @objc private func doneButtonTapped() {
        let placeVC = PlaceViewController(viewModel: viewModel.getPlaceViewModel())
        placeVC.placeView.placeLocationTextField.text = self.mapScreenView.currentPlaceLabel.text
        dismiss(animated: true)
    }
    
    @objc private func getDirectionTapped() {

        mapManager.getDirections(mapView: mapScreenView.mapView) { (location) in
            self.previousLocation = location
        }
    }
    
    @objc private func centerViewInUserLocation() {
                
        //getAddress(mapScreenView.currentPlaceLabel.text)
        mapManager.showUserLocation(mapView: mapScreenView.mapView)
    }
    
    func getAddress(_ address: String?) -> String {
        guard let address = address else { return "" }
        return address
    }
    
}

extension MapScreenViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        guard !(annotation is MKUserLocation) else { return nil }
        
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: annotationIdentifier) as? MKMarkerAnnotationView
        
        if annotationView == nil {
            annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: annotationIdentifier)
            annotationView?.canShowCallout = true
        }
                
        if let imageData = viewModel.currentPlace?.imageData {
            
            let imageView: UIImageView = {
                let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
                imageView.layer.cornerRadius = 10
                imageView.clipsToBounds = true
                imageView.image = UIImage(data: imageData)
                return imageView
            }()
            
            annotationView?.rightCalloutAccessoryView = imageView
        }
        
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        
        let center = mapManager.getCenterLocation(for: mapScreenView.mapView)
        let geocoder = CLGeocoder()
        
        if incomeIdentifier == "showPlace" && previousLocation != nil {
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                self.mapManager.showUserLocation(mapView: self.mapScreenView.mapView)
            }
        }
        
        geocoder.cancelGeocode()
        
        geocoder.reverseGeocodeLocation(center) { placemarks, error in
            
            if let error = error {
                print(error)
                return
            }
            
            guard let placemarks = placemarks else { return }
            
            let placemark = placemarks.first
            let streetName = placemark?.thoroughfare
            let buildingNumber = placemark?.subThoroughfare
            
            DispatchQueue.main.async {
                
                if streetName != nil && buildingNumber != nil {
                    self.mapScreenView.currentPlaceLabel.text = "\(streetName!), \(buildingNumber!)"
                } else if streetName != nil {
                    self.mapScreenView.currentPlaceLabel.text = "\(streetName!)"
                } else {
                    self.mapScreenView.currentPlaceLabel.text = ""
                }
            }
        }
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        
        let renderer = MKPolylineRenderer(overlay: overlay as! MKPolyline)
        renderer.strokeColor = .blue
        
        return renderer
    }
}

extension MapScreenViewController: CLLocationManagerDelegate {
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        mapManager.checkLocationAuthorization(mapView: mapScreenView.mapView, incomeIdentifier: incomeIdentifier)
    }
}

extension MapScreenViewController {
    
    private func setupMapView() {
        
        viewModel.getCurrentPlace()
                
        mapManager.checkLocationServices(mapView: mapScreenView.mapView, incomeIdentifier: incomeIdentifier) {
            mapManager.locationManager.delegate = self
        }
        
        mapScreenView.getDirectionButton.isHidden = true
        
        if incomeIdentifier == "showPlace" {
            
            guard let place = viewModel.currentPlace else { return }
            mapManager.setupPlacemark(place: place, mapView: mapScreenView.mapView)
            mapScreenView.currentPlaceLabel.isHidden = true
            mapScreenView.pinImage.isHidden = true
            mapScreenView.doneButton.isHidden = true
            mapScreenView.getDirectionButton.isHidden = false
        }
    }
    
    private func setupInterface() {
        
        mapScreenView.cancelButton.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
        mapScreenView.userLocationButton.addTarget(self, action: #selector(centerViewInUserLocation), for: .touchUpInside)
        mapScreenView.doneButton.addTarget(self, action: #selector(doneButtonTapped), for: .touchUpInside)
        mapScreenView.getDirectionButton.addTarget(self, action: #selector(getDirectionTapped), for: .touchUpInside)
    }
}
