import ObjectMapper

struct PlaceCoordinates {
    var latitude: Double
    var longtitude: Double
}

extension PlaceCoordinates: Mappable {
    init?(map: Map) {
        latitude = 0
        longtitude = 0
    }
    
    mutating func mapping(map: Map) {
        latitude <- map["lat"]
        longtitude <- map["lng"]
    }
}


