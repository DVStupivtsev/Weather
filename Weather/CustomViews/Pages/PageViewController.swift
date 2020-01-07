//
//  Created by Dmitriy Stupivtsev on 05/05/2019.
//

import UIKit
import Prelude

typealias PageViewControllerType = BaseViewController<PageView>
    & UIPageViewControllerDataSource
    & UIPageViewControllerDelegate

final class PageViewController: PageViewControllerType {
    private let pageViewController = UIPageViewController(
        transitionStyle: .scroll,
        navigationOrientation: .horizontal
    )
    
    private var controllers: [UIViewController]
    private var currentIndex = 0
    
    init(controllers: [UIViewController]) {
        self.controllers = controllers
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addChild(pageViewController)
        pageViewController.didMove(toParent: self)
        customView.addPageView(pageViewController.view)
        
        updatePagesCount()
        updateCurrentPage(animated: false)
    }
    
    private func updatePagesCount() {
        let count = controllers.count
        let isMultiplePages = count > 1
        let delegate = isMultiplePages ? self : nil
        
        // without delegate pages don't scroll,
        // so we remove it when pages count less than 2
        pageViewController.delegate = delegate
        pageViewController.dataSource = delegate
        
        customView.setPagesCount(count)
        
        if isMultiplePages {
            customView.showPagesIndicator()
        } else {
            customView.hidePagesIndicator()
        }
    }
    
    private func updateCurrentPage(animated: Bool) {
        customView.setCurrentPageIndex(currentIndex)
        
        let controller = controllers[currentIndex]
        pageViewController.setViewControllers([controller], direction: .forward, animated: animated)
    }
    
    func updateControllers(_ controllers: [UIViewController]) {
        self.controllers = controllers
        updatePagesCount()
    }
    
    func setCurrentControllerIndex(_ index: Int) {
        currentIndex = index
        updateCurrentPage(animated: true)
    }
    
    // MARK: - <UIPageViewControllerDataSource/Delegate>
    
    // TODO: - Move to separated data source
    
    func pageViewController(
        _ pageViewController: UIPageViewController,
        willTransitionTo pendingViewControllers: [UIViewController]
    ) {
        pendingViewControllers.first.flatMap(controllers.firstIndex).do {
            currentIndex = $0
        }
    }
    
    func pageViewController(
        _ pageViewController: UIPageViewController,
        didFinishAnimating finished: Bool,
        previousViewControllers: [UIViewController],
        transitionCompleted completed: Bool
    ) {
        guard completed else { return }
        
        customView.setCurrentPageIndex(currentIndex)
    }
    
    func pageViewController(
        _ pageViewController: UIPageViewController,
        viewControllerBefore viewController: UIViewController
    ) -> UIViewController? {
        controllers.firstIndex(of: viewController).flatMap { index in
            index > 0
                ? controllers[index - 1]
                : nil
        }
    }
    
    func pageViewController(
        _ pageViewController: UIPageViewController,
        viewControllerAfter viewController: UIViewController
    ) -> UIViewController? {
        controllers.firstIndex(of: viewController).flatMap { index in
            index < controllers.count - 1
                ? controllers[index + 1]
                : nil
        }
    }
}
