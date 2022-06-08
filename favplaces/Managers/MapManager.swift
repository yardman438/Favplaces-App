//
//  MapManager.swift
//  favplaces
//
//  Created by Serhii Dvornyk on 08.06.2022.
//

import UIKit
import MapKit

protocol MapProvider {
    
    func setupPlacemark(place: DBObject, mapView: MKMapView)
    func checkLocationServices(mapView: MKMapView, incomeIdentifier: String, completion: () -> Void)
    func checkLocationAuthorization(mapView: MKMapView, incomeIdentifier: String)
    func showUserLocation(mapView: MKMapView)
    func getDirections(mapView: MKMapView, previousLocation: (CLLocation) -> Void)
    func createDirectionRequest(from coordinate: CLLocationCoordinate2D) -> MKDirections.Request?
    func startTrackingUserLocation(mapView: MKMapView, location: CLLocation?, completion: (_ currentLocation: CLLocation) -> Void)
    func resetMapView(withNew directions: MKDirections, mapView: MKMapView)
    func getCenterLocation(for mapView: MKMapView) -> CLLocation
    
}

class MapManager: MapProvider {
    
    let locationManager =  CLLocationManager()
    
    private let regionInMeters = 1000.0
    private var placeCoordinate: CLLocationCoordinate2D?
    private var directionsArray: [MKDirections] = []

    //Setup the placemark of current place
    func setupPlacemark(place: DBObject, mapView: MKMapView) {
                
        guard let location = place.location else { return }
        
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(location) { (placemarks, error) in
            
            if let error = error {
                print(error)
                return
            }
            
            guard let placemarks = placemarks else { return }
            
            let placemark = placemarks.first
            
            let annotation = MKPointAnnotation()
            annotation.title = place.name
            annotation.subtitle = place.type
            
            guard let placemarkLocation = placemark?.location else { return }
            
            annotation.coordinate = placemarkLocation.coordinate
            
            mapView.showAnnotations([annotation], animated: true)
            mapView.selectAnnotation(annotation, animated: true)
        }
    }
    
    //Checking the availability of geolocation services
    func checkLocationServices(mapView: MKMapView, incomeIdentifier: String, completion: () -> Void) {
        
        if CLLocationManager.locationServicesEnabled() {
            
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            checkLocationAuthorization(mapView: mapView, incomeIdentifier: incomeIdentifier)
            completion()
        } else {
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.showAlert(title: "Your location is disabled",
                               message: "To give permission Go to: Settings -> Privacy -> Location services and turn On")
            }
        }
    }
    
    //Verification of application authorization to use geolocation services
    func checkLocationAuthorization(mapView: MKMapView, incomeIdentifier: String) {
        
        switch locationManager.authorizationStatus {
        case .authorizedWhenInUse:
            mapView.showsUserLocation = true
            if incomeIdentifier == "getAddress" {
                showUserLocation(mapView: mapView)
            }
            break
        case .denied:
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.showAlert(title: "Your location is not available",
                               message: "To give permission Go to: Settings -> Places -> Location")
            }
            break
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
            break
        case .restricted:
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.showAlert(title: "Your location is not available",
                               message: "To give permission Go to: Settings -> Places -> Location")
            }
            break
        case .authorizedAlways:
            break
        @unknown default:
            print("New case is added")
        }
    }
    
    //Focus of the map on the user's location
    func showUserLocation(mapView: MKMapView) {
        
        if let location = locationManager.location?.coordinate {
            
            let region = MKCoordinateRegion(center: location,
                                            latitudinalMeters: regionInMeters,
                                            longitudinalMeters: regionInMeters)
            
            mapView.setRegion(region, animated: true)
        }
    }
    
    //Make a route from user's location to the destination
    func getDirections(mapView: MKMapView, previousLocation: (CLLocation) -> Void) {
        
        guard let location = locationManager.location?.coordinate else {
            showAlert(title: "Error", message: "Current location is not found")
            return
        }
        
        locationManager.startUpdatingLocation()
        previousLocation(CLLocation(latitude: location.latitude, longitude: location.longitude))
        
        guard let request = createDirectionRequest(from: location) else {
            showAlert(title: "Error", message: "Destination is not found")
            return
        }
        
        let directions = MKDirections(request: request)
        resetMapView(withNew: directions, mapView: mapView)
        
        directions.calculate { (response, error) in
                        
            if let error = error {
                print(error)
                return
            }
            
            guard let response = response else {
                self.showAlert(title: "Error", message: "Directions is not available")
                return
            }
            
            for route in response.routes {
                mapView.addOverlay(route.polyline)
                mapView.setVisibleMapRect(route.polyline.boundingMapRect, animated: true)
                
                let distance = String(format: "%.1f", route.distance / 1000)
                let timeInterval = route.expectedTravelTime
                
                print("Distance: \(distance) km")
                print("Time: \(timeInterval) sec")
            }
        }
    }
    
    //Setup request for route calculation
    func createDirectionRequest(from coordinate: CLLocationCoordinate2D) -> MKDirections.Request? {
        
        guard let destinationCoordinate = placeCoordinate else { return nil }
        let startingLocation = MKPlacemark(coordinate: coordinate)
        let destination = MKPlacemark(coordinate: destinationCoordinate)
        
        let request = MKDirections.Request()
        request.source = MKMapItem(placemark: startingLocation)
        request.destination = MKMapItem(placemark: destination)
        request.transportType = .walking
        request.requestsAlternateRoutes = true
        
        return request
    }
    
    //Changing the displayed area of the map area when user is moving
    func startTrackingUserLocation(mapView: MKMapView, location: CLLocation?, completion: (_ currentLocation: CLLocation) -> Void) {
        
        guard let location = location else { return }
        let center = getCenterLocation(for: mapView)
        guard center.distance(from: location) > 50 else { return }
        
        completion(center)
    }
    
    //Resetting previously built routes
    func resetMapView(withNew directions: MKDirections, mapView: MKMapView) {
        
        mapView.removeOverlays(mapView.overlays)
        directionsArray.append(directions)
        let _ = directionsArray.map { $0.cancel() }
        directionsArray.removeAll()
    }
    
    //Setup the center of the displayed area of the map
    func getCenterLocation(for mapView: MKMapView) -> CLLocation {
        
        let latitude = mapView.centerCoordinate.latitude
        let longitude = mapView.centerCoordinate.longitude
        let coordinates = CLLocation(latitude: latitude, longitude: longitude)
        placeCoordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        
        return coordinates
    }
    
    private func showAlert(title: String, message: String) {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "Ok", style: .default)
        alertController.addAction(okAction)
        
        let alertWindow = UIWindow(frame: UIScreen.main.bounds)
        alertWindow.rootViewController = UIViewController()
        alertWindow.windowLevel = UIWindow.Level.alert + 1
        alertWindow.makeKeyAndVisible()
        alertWindow.rootViewController?.present(alertController, animated: true)
    }
}
