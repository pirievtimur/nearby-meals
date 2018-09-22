import UIKit
import Moya

class ViewController: UIViewController {
    
    private let mealsAPI: MealAPI = APIService()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let coordinates = PlaceCoordinates(latitude: -33.8670522, longtitude: 151.1957362)
        mealsAPI.mealPlaces(type: .restaurant, coordinates: coordinates)
    }
}

