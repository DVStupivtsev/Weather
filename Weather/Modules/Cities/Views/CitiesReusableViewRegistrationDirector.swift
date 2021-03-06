//
//  Created by Dmitriy Stupivtsev on 12/05/2019.
//

import UIKit

struct CitiesReusableViewRegistrationDirector: TableReusableViewRegistrationDirector {
    func registerViews(using registrator: TableReusableViewRegistrator) {
        let classes = [CityTableCell.self, CitiesHeaderTableCell.self]
        classes.forEach(registrator.register(type:))
    }
}
