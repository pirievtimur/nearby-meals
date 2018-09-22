import Moya

protocol MealAPI {
    func mealPlaces(type: MealPlaceType, coordinates: PlaceCoordinates)
}

extension APIService: MealAPI {
    func mealPlaces(type: MealPlaceType, coordinates: PlaceCoordinates) {
        let provider = MoyaProvider<APIProvider>()
        let request = APIProvider.places(type: type.rawValue,
                                         latitude: coordinates.latitude,
                                         longtitude: coordinates.longtitude)
        provider.request(request) { result in
            switch result {
            case .success(let value):
                print(value)
            case .failure(_):
                break
            }
        }
    }
}

enum APIProvider {
    case places(type: String, latitude: Double, longtitude: Double)
}

extension APIProvider: TargetType {
    var baseURL: URL {
        switch self {
        case .places(_, _, _):
            return URL(string: "https://maps.googleapis.com")!
        }
    }
    
    var path: String {
        switch self {
        case .places(_, _, _):
            return "maps/api/place/nearbysearch/json"
        }
    }
    
    var method: Method {
        switch self {
        case .places(_, _, _):
            return .get
        }
    }
    
    var sampleData: Data {
        switch self {
        case .places(_, _, _):
            return Data()
        }
    }
    
    var task: Task {
        switch self {
        case .places(let type, let latitude, let longtitude):
            let parameters: [String:Any] = [
                "key" : "AIzaSyDglUBKn9jTHcmIUUKgq9zwxFmehxDPrUc",
                "type" : type,
                "location" : "\(latitude),\(longtitude)",
                "radius" : 500
            ]
            return .requestParameters(parameters: parameters,
                                      encoding: URLEncoding.queryString)
        }
    }
    
    var headers: [String: String]? {
        return ["Content-type": "application/json"]
    }
}
