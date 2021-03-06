//
//  Created by Dmitriy Stupivtsev on 13/05/2019.
//

import UIKit
import Weakify

final class CitySearchViewController: BaseViewController<CitySearchView> {
    private let viewModel: CitySearchViewModel
    private let keyboardObserver: KeyboardObserver
    
    private var tableSource: TableDataSource = .empty
    
    init(viewModel: CitySearchViewModel, keyboardObserver: KeyboardObserver) {
        self.viewModel = viewModel
        self.keyboardObserver = keyboardObserver
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        customView.setupCloseAction(weakify(self, type(of: self).close))
        customView.setupTextFieldBehavior(CitySearchTextFieldBehavior(delegate: viewModel.textEditingDelegate))
        customView.registerViews(with: CitySearchReusableViewRegistrationDirector())
        
        keyboardObserver.startObserving(
            handler: weakify(self, type(of: self).changeTableInsets(with:))
        )
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        customView.startSearching()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        customView.stopSearching()
        
        super.viewWillDisappear(animated)
    }
    
    private func changeTableInsets(with info: KeyboardInfo) {
        let insets = UIEdgeInsets(top: 0, left: 0, bottom: info.verticalOffset, right: 0)
        customView.updateTableInsets(insets)
    }
    
    private func close() {
        viewModel.close()
    }
}

extension CitySearchViewController: CitySearchViewUpdatable {
    func update(providerConvertibles: [TableCellProviderConvertible]) {
        let sectionSource = TableSectionSource(cellProviderConvertibles: providerConvertibles)
        tableSource = TableDataSource(
            sources: [sectionSource],
            selectionBehavior: viewModel.selectionBehavior
        )
        
        customView.update(tableSource: tableSource)
    }
}
