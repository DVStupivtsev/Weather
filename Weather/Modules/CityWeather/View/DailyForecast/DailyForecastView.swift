//
//  Created by Dmitriy Stupivtsev on 10/05/2019.
//

import UIKit
import SnapKit

final class DailyForecastView: BaseView {
    private let appearance = Appearance()
    
    private let tableView = make(object: UITableView()) {
        $0.tableFooterView = UIView()
        $0.separatorStyle = .none
        $0.backgroundColor = .clear
    }
    
    override func commonInit() {
        super.commonInit()
        
        setupSubviews()
        setupConstraints()
    }
    
    private func setupSubviews() {
        backgroundColor = Color.white
        
        addSubview(tableView)
    }
    
    private func setupConstraints() {
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        roundCorners([.topLeft, .topRight], radius: appearance.cornerRadius)
    }
}

private extension DailyForecastView {
    struct Appearance {
        let cornerRadius: CGFloat = 16
    }
}