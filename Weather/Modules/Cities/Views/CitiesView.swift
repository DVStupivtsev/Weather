//
//  Created by Dmitriy Stupivtsev on 27/04/2019.
//

import UIKit
import SnapKit

final class CitiesView: BaseView {
    private let tableView = make(object: UITableView()) {
        $0.backgroundColor = .white
        $0.tableFooterView = UIView()
        $0.separatorStyle = .none
    }
    
    override func commonInit() {
        super.commonInit()
        
        setupSubviews()
        setupConstraints()
    }
    
    private func setupSubviews() {
        addSubview(tableView)
    }
    
    private func setupConstraints() {
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}