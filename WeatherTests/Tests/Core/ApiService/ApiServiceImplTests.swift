//
//  Created by Dmitriy Stupivtsev on 27/04/2019.
//

import XCTest
@testable import Promises
@testable import Weather

final class ApiServiceImplTests: XCTestCase {
    private var urlService: UrlServiceMock!
    private var subject: ApiServiceImpl!
    
    override func setUp() {
        super.setUp()
        
        urlService = UrlServiceMock()
        subject = ApiServiceImpl(urlService: urlService)
    }
    
    func testExecuteWithValidUrlSuccess() {
        urlService.dataTaskWithReturnValue = Promise<Data?>.pending()
        
        var receivedValue: Data?
        var receivedError: Error?
        subject.execute(request: validRequest)
            .then { receivedValue = $0 }
            .catch { receivedError = $0 }
        
        XCTAssertEqual(urlService.dataTaskWithCallsCount, 1, "should call urlService")
        XCTAssertEqual(urlService.dataTaskWithReceivedUrl?.absoluteString, validUrlString, "should call urlService")
        
        let expectedData = Data()
        urlService.dataTaskWithReturnValue.fulfill(expectedData)
        XCTAssert(waitForPromises(timeout: 1))
        XCTAssertEqual(receivedValue, expectedData, "should receive success with data")
        XCTAssertNil(receivedError, "shouldn't receive error")
    }
    
    func testExecuteWithValidUrlFailure() {
        urlService.dataTaskWithReturnValue = Promise<Data?>.pending()
        
        var receivedValue: Data?
        var receivedError: Error?
        subject.execute(request: validRequest)
            .then { receivedValue = $0 }
            .catch { receivedError = $0 }
        
        XCTAssertEqual(urlService.dataTaskWithCallsCount, 1, "should call urlService")
        XCTAssertEqual(urlService.dataTaskWithReceivedUrl?.absoluteString, validUrlString, "should call urlService")
        
        let expectedError = NSError.error(message: "TestError")
        urlService.dataTaskWithReturnValue.reject(expectedError)
        XCTAssert(waitForPromises(timeout: 1))
        XCTAssertNil(receivedValue, "shouldn't receive data")
        XCTAssertEqual(receivedError as NSError?, expectedError, "should receive error")
    }
    
    func testExecuteWithInvalidUrl() {
        var receivedValue: Data?
        var receivedError: Error?
        subject.execute(request: invalidRequest)
            .then { receivedValue = $0 }
            .catch { receivedError = $0 }
        
        XCTAssertEqual(urlService.dataTaskWithCallsCount, 0, "shouldn't call urlService")
        
        XCTAssert(waitForPromises(timeout: 1))
        XCTAssertEqual(receivedError as NSError?, NSError.common, "should receive error")
        XCTAssertNil(receivedValue, "shouldn't receive value")
    }
}

private extension ApiServiceImplTests {
    private var validRequest: ApiServiceRequest {
        return ApiServiceRequest(name: "TestName", parameters: ["TestKey": "TestValue"])
    }
    
    private var invalidRequest: ApiServiceRequest {
        return ApiServiceRequest(name: " TestName", parameters: ["TestKey": "TestValue"])
    }
    
    private var validUrlString: String {
        return "https://api.openweathermap.org/data/2.5/TestName?TestKey=TestValue&APPID=95ff45a9380c75f19a9a9ef20502dac9"
    }
}