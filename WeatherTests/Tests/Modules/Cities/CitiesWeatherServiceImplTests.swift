//
//  Created by Dmitriy Stupivtsev on 28/04/2019.
//

import XCTest
@testable import Promises
@testable import Weather

final class CitiesWeatherServiceImplTests: XCTestCase {
    var apiService: ApiServiceMock!
    var subject: CitiesWeatherServiceImpl!
    
    override func setUp() {
        super.setUp()
        
        apiService = ApiServiceMock()
        subject = CitiesWeatherServiceImpl(apiService: apiService)
    }
    
    func testGetWeatherWithValidJson() {
        apiService.executeRequestReturnValue = Promise<Data?>.pending()
        
        var receivedValue: CitiesResponse?
        var receivedError: Error?
        subject.getWeather(for: cities)
            .then { receivedValue = $0 }
            .catch { receivedError = $0 }
        
        XCTAssertEqual(
            apiService.executeRequestCallsCount,
            1,
            "should call apiService once, got \(apiService.executeRequestCallsCount)"
        )
        
        compare(expected: request, received: apiService.executeRequestReceivedRequest)
        
        apiService.executeRequestReturnValue.fulfill(validJson)
        XCTAssert(waitForPromises(timeout: 1))
        compare(expected: expectedCitiesResponse, received: receivedValue)
        XCTAssertNil(receivedError, "shouldn't receive error")
    }
    
    func testGetWeatherWithInvalidJson() {
        apiService.executeRequestReturnValue = Promise<Data?>.pending()
        
        var receivedValue: CitiesResponse?
        var receivedError: Error?
        subject.getWeather(for: cities)
            .then { receivedValue = $0 }
            .catch { receivedError = $0 }
        
        XCTAssertEqual(
            apiService.executeRequestCallsCount,
            1,
            "should call apiService once, got \(apiService.executeRequestCallsCount)"
        )
        
        compare(expected: request, received: apiService.executeRequestReceivedRequest)
        
        apiService.executeRequestReturnValue.fulfill(invalidJson)
        XCTAssert(waitForPromises(timeout: 1))
        XCTAssertNil(receivedValue, "shouldn't receive value")
        XCTAssertNotNil(receivedError, "should receive error")
    }
    
    func testGetWeatherWithNilData() {
        apiService.executeRequestReturnValue = Promise<Data?>.pending()
        
        var receivedValue: CitiesResponse?
        var receivedError: Error?
        subject.getWeather(for: cities)
            .then { receivedValue = $0 }
            .catch { receivedError = $0 }
        
        XCTAssertEqual(
            apiService.executeRequestCallsCount,
            1,
            "should call apiService once, got \(apiService.executeRequestCallsCount)"
        )
        
        compare(expected: request, received: apiService.executeRequestReceivedRequest)
        
        apiService.executeRequestReturnValue.fulfill(nil)
        XCTAssert(waitForPromises(timeout: 1))
        XCTAssertNil(receivedValue, "shouldn't receive value")
        compare(expected: NSError.common, received: receivedError as NSError?)
    }
}

private extension CitiesWeatherServiceImplTests {
    var expectedCitiesResponse: CitiesResponse {
        return CitiesResponse(cities: [])
    }
    
    var validJson: Data {
        return try! JSONEncoder().encode(expectedCitiesResponse)
    }
    
    var invalidJson: Data {
        return Data()
    }
    
    var cities: [String] {
        return ["123", "42134", "asdfasd"]
    }
    
    var request: ApiServiceRequest {
        return ApiServiceRequest(
            name: "group",
            parameters: [
                "id": cities.joined(separator: ","),
                "units": "metric"
            ]
        )
    }
}