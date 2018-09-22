protocol MainPresenterProtocol {
    init(view: MainViewProtocol)
    func loadPlaces(type: PlaceType, coordinates: PlaceCoordinates)
}

class MainPresenter: MainPresenterProtocol {
    unowned var view: MainViewProtocol
    
    private let placesAPI: PlacesAPI = APIService()
    
    required init(view: MainViewProtocol) {
        self.view = view
    }
    
    func loadPlaces(type: PlaceType, coordinates: PlaceCoordinates) {
            placesAPI.getPlaces(type: .restaurant,
                                coordinates: coordinates,
                                callback: { [weak self] (places, error) in
                self?.view.reloadPlaces(annotations: places.map { PlaceAnnotation(place: $0) })
            })
    }
}
