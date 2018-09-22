import MapKit

class PlaceAnnotation: NSObject, MKAnnotation {
    let title: String?
    let address: String?
    let coordinate: CLLocationCoordinate2D
    
    init(place: Place) {
        self.title = place.name
        self.address = place.address
        self.coordinate = CLLocationCoordinate2DMake(place.coordinates.latitude,
                                                     place.coordinates.longtitude)
        
        super.init()
    }
    
    var subtitle: String? {
        return address
    }
}
