import UIKit

private var CustomOptions: Void?

extension UIViewController {
    
    var defaultOptions: [SemiModalOption: Any] {
        return [
            .traverseParentHierarchy : true,
            .pushParentBack          : false,
            .animationDuration       : 0.5,
            .parentAlpha             : 0.5,
            .parentScale             : 0.8,
            .shadowOpacity           : 0.5,
            .transitionStyle         : SemiModalTransitionStyle.slideUp,
            .disableCancel           : true
        ]
    }
  
    func registerOptions(_ options: [SemiModalOption: Any]?) {
        // options always save in parent viewController
        var targetVC: UIViewController = self
        while targetVC.parent != nil {
            targetVC = targetVC.parent!
        }
        
        objc_setAssociatedObject(targetVC, &CustomOptions, options, .OBJC_ASSOCIATION_RETAIN)
    }
    
    func options() -> [SemiModalOption: Any] {
        var targetVC: UIViewController = self
        while targetVC.parent != nil {
            targetVC = targetVC.parent!
        }
        
        if let options = objc_getAssociatedObject(targetVC, &CustomOptions) as? [SemiModalOption: Any] {
            var defaultOptions: [SemiModalOption: Any] = self.defaultOptions
            defaultOptions.merge(options) { (_, new) in new }
            
            return defaultOptions
        } else {
            return defaultOptions
        }
    }
    
    func optionForKey(_ optionKey: SemiModalOption) -> Any? {
        let options = self.options()
        let value = options[optionKey]
      
        switch optionKey {
        case .traverseParentHierarchy, .pushParentBack, .disableCancel:
            if let value = value as? Bool {
                return value
            }else{
                return defaultOptions[optionKey]
            }
        case .animationDuration:
            if let value = value as? TimeInterval {
                return value
            }else{
                return defaultOptions[optionKey]
            }
        case .parentAlpha, .parentScale, .shadowOpacity:
            if let value = value as? Double {
                return value
            }else{
                return defaultOptions[optionKey]
            }
        case .transitionStyle:
            if let value = value as? SemiModalTransitionStyle {
                return value
            }else{
                return defaultOptions[optionKey]
            }
        case .backgroundView:
            if let value = value as? UIView {
                return value
            }else{
                return defaultOptions[optionKey]
            }
        }
        
    }

}
