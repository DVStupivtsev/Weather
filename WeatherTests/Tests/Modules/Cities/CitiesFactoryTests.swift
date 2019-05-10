//
//  Created by Dmitriy Stupivtsev on 10/05/2019.
//

import XCTest
@testable import Weather

final class CitiesFactoryTests: XCTestCase {
    func testCreate() {
        let subject = CitiesFactory()
        let receivedController = subject.create(router: CitiesRouterMock())
        
        XCTAssert(
            receivedController,
            isKindOf: CitiesViewController.self,
            "expected value is \(CitiesViewController.self), got \(type(of: receivedController))"
        )
    }
}
