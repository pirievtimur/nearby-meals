import UIKit
import MapKit
import CoreLocation

protocol MainViewProtocol: class {
    func reloadPlaces(annotations: [PlaceAnnotation])
}

class MainViewController: UIViewController {
    
    fileprivate lazy var presenter: MainPresenterProtocol = MainPresenter(view: self)
    fileprivate let locationManager = CLLocationManager()
    
    private var currentCoordinate: CLLocationCoordinate2D?
    
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        checkLocationAuthorizationStatus()
        
    }
    
    deinit {
        locationManager.monitoredRegions.forEach {
            locationManager.stopMonitoring(for: $0)
        }
    }
    
    @IBAction func getRestaurants(_ sender: Any) {
        presenter.loadPlaces(type: .restaurant,
                             coordinates: getCurrentCoordinates())
    }
    
    @IBAction func getCafes(_ sender: Any) {
        presenter.loadPlaces(type: .cafe,
                             coordinates: getCurrentCoordinates())
    }
    
    @IBAction func getBars(_ sender: Any) {
        presenter.loadPlaces(type: .bar,
                             coordinates: getCurrentCoordinates())
    }
    
    private func getCurrentCoordinates() -> PlaceCoordinates {
        let mapViewCoordinates = mapView.centerCoordinate
        
        return PlaceCoordinates(latitude: mapViewCoordinates.latitude,
                                longtitude: mapViewCoordinates.longitude)
    }
    
    private func checkLocationAuthorizationStatus() {
        locationManager.delegate = self
        let status = CLLocationManager.authorizationStatus()
        
        if status == .notDetermined {
            locationManager.requestAlwaysAuthorization()
        } else if status == .authorizedAlways || status == .authorizedWhenInUse {
         beginLocationsUpdate(locationManager: locationManager)
        }
    }
    
    private func beginLocationsUpdate(locationManager: CLLocationManager) {
        mapView.showsUserLocation = true
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.startUpdatingLocation()
    }
}

extension MainViewController: MainViewProtocol {
    func reloadPlaces(annotations: [PlaceAnnotation]) {
        mapView.removeAnnotations(mapView.annotations)
        mapView.addAnnotations(annotations)
    }
}

extension MainViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard let annotation = annotation as? PlaceAnnotation else { return nil }
        
        let identifier = "place"
        var view: MKMarkerAnnotationView
        if let dequeuedView = mapView
            .dequeueReusableAnnotationView(withIdentifier: identifier) as? MKMarkerAnnotationView {
            dequeuedView.annotation = annotation
            view = dequeuedView
        } else {
            view = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            view.canShowCallout = true
            view.calloutOffset = CGPoint(x: -5, y: 5)
            view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        return view
    }
}

extension MainViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let latestLocation = locations.first else { return }
        
        if currentCoordinate == nil {
            let mapRegion = MKCoordinateRegionMakeWithDistance(latestLocation.coordinate, 1000, 1000)
            mapView.setRegion(mapRegion, animated: false)
        }
        
        currentCoordinate = latestLocation.coordinate
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse || status == .authorizedAlways {
            beginLocationsUpdate(locationManager: locationManager)
        }
    }
}
