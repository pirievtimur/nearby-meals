import Moya
import ObjectMapper

protocol PlacesAPI {
    func getPlaces(type: PlaceType, coordinates: PlaceCoordinates, callback: (([Place], Error?) -> Void)?)
}

extension APIService: PlacesAPI {
    func getPlaces(type: PlaceType, coordinates: PlaceCoordinates, callback: (([Place], Error?) -> Void)? = nil) {
        let provider = MoyaProvider<APIProvider>()
        let request = APIProvider.places(type: type.rawValue,
                                         latitude: coordinates.latitude,
                                         longtitude: coordinates.longtitude)
        provider.request(request) { result in
            switch result {
            case .success(let value):
                guard
                    let json = try? JSONSerialization.jsonObject(with: value.data, options: []) as? [String: Any],
                    let results = Mapper<Place>().mapArray(JSONObject: json?["results"]) else {
                        if let callback = callback { callback([], nil) }
                        return
                    }
                
                if let callback = callback { callback(results, nil) }
            case .failure(let error):
                if let callback = callback { callback([], error) }
                break
            }
        }
    }
}

