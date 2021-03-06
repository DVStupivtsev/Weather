//
//  Created by Dmitriy Stupivtsev on 06/05/2019.
//

import UIKit

// sourcery: AutoMockable
protocol CitySearchFactory {
    func create(selectStrategy: CitySearchSelectStrategy, persistentStore: CitySearchService) -> UIViewController
}
