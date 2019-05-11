//
//  Created by Dmitriy Stupivtsev on 10/05/2019.
//

import Foundation
@testable import Weather

extension City {
    static let city1 = City(
        id: 1,
        name: "Name1",
        date: Date(timeIntervalSince1970: 1557569160),
        coordinate: .init(lat: 1, lon: 2),
        weather: [.init(description: "Desc1", icon: "Icon1")],
        main: .init(temp: 1)
    )
    
    static let city2 = City(
        id: 2,
        name: "Name2",
        date: Date(timeIntervalSince1970: 1557569160),
        coordinate: .init(lat: 2, lon: 3),
        weather: [.init(description: "Desc2", icon: "Icon2")],
        main: .init(temp: 2)
    )
}
