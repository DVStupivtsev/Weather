//
//  Created by Dmitriy Stupivtsev on 11/05/2019.
//

import Foundation
import Promises
import Weakify

final class CityWeatherViewModelImpl: CityWeatherViewModel {
    private let citySource: CitySource
    private let numberFormatter: NumberFormatterProtocol
    private let dateFormatter: DateFormatterProtocol
    private let cityWeatherService: CityWeatherService
    
    private(set) lazy var mainSource = createMainSource()
    
    init(
        citySource: CitySource,
        numberFormatter: NumberFormatterProtocol,
        dateFormatter: DateFormatterProtocol,
        cityWeatherService: CityWeatherService
    ) {
        self.citySource = citySource
        self.numberFormatter = numberFormatter
        self.dateFormatter = dateFormatter
        self.cityWeatherService = cityWeatherService
    }
    
    private func createMainSource() -> CityWeatherViewSource.Main {
        return CityWeatherViewSource.Main(
            cityName: citySource.city.name.uppercased(),
            temperatue: numberFormatter.string(from: citySource.city.main.temp),
            degreeSymbol: "°",
            weatherStatus: citySource.city.weather.first?.description.uppercased() ?? "",
            dateString: dateFormatter.string(from: citySource.city.date).uppercased()
        )
    }
    
    func getDailyForecastSource() -> Promise<[CellProviderConvertible]> {
        return cityWeatherService
            .getDailyForecast(for: citySource.city.id)
            .then(createCellProviders(with:))
    }
    
    private func createCellProviders(with dailyForecast: [DayWeather]) -> [CellProviderConvertible] {
        return dailyForecast.map { _ in DailyForecastCell.Model() }
    }
}
