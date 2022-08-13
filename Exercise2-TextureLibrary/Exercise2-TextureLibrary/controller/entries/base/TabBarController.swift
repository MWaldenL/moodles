import Foundation
import UIKit
import RxSwift


class TabBarController: UITabBarController {
    let disposeBag = DisposeBag()
    var layerHeight = CGFloat()
    let middleButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(
            systemName: "plus.circle.fill",
            withConfiguration:
                UIImage.SymbolConfiguration(
                    pointSize: 70,
                    weight: .heavy,
                    scale: .large)),
            for: .normal)
        button.imageView?.tintColor = .white
        button.backgroundColor = Styles.Color.babyBlue2
        button.setTitleColor(Styles.Color.primary, for: .selected)
        return button
    }()
    
    fileprivate lazy var defaultTabBarHeight = { tabBar.frame.size.height }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setViewControllers([ViewController(), NavInsightsViewController()], animated: false)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tabBar.frame.size.height = 100
        tabBar.frame.origin.y = view.frame.size.height - 100
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.tabBar.unselectedItemTintColor = Styles.Color.primary
        
        self.tabBar.items?[0].title = nil
        self.tabBar.items?[0].image = UIImage(systemName: "list.bullet")
        self.tabBar.items?[0].selectedImage = UIImage(systemName: "list.bullet")
        
        self.tabBar.items?[1].title = nil
        self.tabBar.items?[1].image = UIImage(systemName: "lightbulb")
        self.tabBar.items?[1].selectedImage = UIImage(systemName: "lightbulb")
        
        if #available(iOS 15.0, *) {
            let appearance = UITabBarAppearance()
            appearance.backgroundColor = Styles.Color.primary
            appearance.stackedLayoutAppearance.normal.iconColor = .white
            appearance.stackedLayoutAppearance.selected.iconColor = Styles.Color.babyBlue2
            self.tabBar.standardAppearance = appearance
            self.tabBar.scrollEdgeAppearance = appearance
        }
        
        self.addMiddleButton()
    }
    
    func addMiddleButton() {
        tabBar.addSubview(middleButton)
        let size = CGFloat(50)
        
        // set constraints
        let constraints = [
            middleButton.centerXAnchor.constraint(
                equalTo: tabBar.centerXAnchor),
            
            middleButton.centerYAnchor.constraint(
                equalTo: tabBar.topAnchor, constant: layerHeight + 10),
            
            middleButton.heightAnchor.constraint(equalToConstant: size),
            middleButton.widthAnchor.constraint(equalToConstant: size)
        ]
        for constraint in constraints {
            constraint.isActive = true
        }
        
        middleButton.layer.cornerRadius = size / 2
        middleButton.layer.shadowColor = UIColor.gray.cgColor
        middleButton.layer.shadowOffset = CGSize(width: 0, height: 8)
        middleButton.layer.shadowOpacity = 0.75
        middleButton.layer.shadowRadius = 10
        middleButton.layer.masksToBounds = false
        middleButton.translatesAutoresizingMaskIntoConstraints = false
        
        middleButton.rx.tap
            .subscribe(onNext: {
                let ind = self.selectedIndex
                
                if ind == 0 { // home vc
                    ((self.viewControllers![0] as! ViewController)
                        .viewControllers[0] as! MainViewController)
                        .navigationController?
                        .pushViewController(
                            MoodViewController(node: MoodViewNode()),
                            animated: true)
                } else { // insights vc
                    ((self.viewControllers![1] as! NavInsightsViewController)
                        .viewControllers[0] as! InsightsViewController)
                        .navigationController?
                        .pushViewController(
                            MoodViewController(node: MoodViewNode()),
                            animated: true)
                }
            })
            .disposed(by: self.disposeBag)
    }
}
