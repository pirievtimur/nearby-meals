import ObjectMapper

struct Place {
    var name: String
    var address: String
    var openedNow: Bool
    var priceLevel: UInt
    var rating: Double
    var coordinates: PlaceCoordinates
}

extension Place: Mappable {
    init?(map: Map) {
        name = ""
        address = ""
        openedNow = false
        priceLevel = 0
        rating = 0
        coordinates = PlaceCoordinates(latitude: 0, longtitude: 0)
    }
    
    mutating func mapping(map: Map) {
        name <- map["name"]
        address <- map["vicinity"]
        openedNow <- map["opening_hours.open_now"]
        priceLevel <- map["price_level"]
        rating <- map["rating"]
        coordinates <- map["geometry.location"]
    }
}
