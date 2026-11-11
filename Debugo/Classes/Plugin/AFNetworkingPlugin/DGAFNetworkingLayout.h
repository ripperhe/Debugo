//
//  DGAFNetworkingLayout.h
//  Debugo
//

#import <UIKit/UIKit.h>

NS_INLINE void DGAFNetworkingDisableAutoresizing(UIView *view) {
    view.translatesAutoresizingMaskIntoConstraints = NO;
}

NS_INLINE NSLayoutConstraint *DGAFNetworkingConstraint(id item, NSLayoutAttribute attribute, NSLayoutRelation relation, id toItem, NSLayoutAttribute toAttribute, CGFloat constant) {
    return [NSLayoutConstraint constraintWithItem:item attribute:attribute relatedBy:relation toItem:toItem attribute:toAttribute multiplier:1 constant:constant];
}

NS_INLINE void DGAFNetworkingPinEdges(UIView *view, UIView *container, UIEdgeInsets insets) {
    DGAFNetworkingDisableAutoresizing(view);
    [NSLayoutConstraint activateConstraints:@[
        DGAFNetworkingConstraint(view, NSLayoutAttributeTop, NSLayoutRelationEqual, container, NSLayoutAttributeTop, insets.top),
        DGAFNetworkingConstraint(view, NSLayoutAttributeLeft, NSLayoutRelationEqual, container, NSLayoutAttributeLeft, insets.left),
        DGAFNetworkingConstraint(container, NSLayoutAttributeBottom, NSLayoutRelationEqual, view, NSLayoutAttributeBottom, insets.bottom),
        DGAFNetworkingConstraint(container, NSLayoutAttributeRight, NSLayoutRelationEqual, view, NSLayoutAttributeRight, insets.right),
    ]];
}

NS_INLINE void DGAFNetworkingPinHorizontal(UIView *view, UIView *container, CGFloat inset) {
    DGAFNetworkingDisableAutoresizing(view);
    [NSLayoutConstraint activateConstraints:@[
        DGAFNetworkingConstraint(view, NSLayoutAttributeLeft, NSLayoutRelationEqual, container, NSLayoutAttributeLeft, inset),
        DGAFNetworkingConstraint(container, NSLayoutAttributeRight, NSLayoutRelationEqual, view, NSLayoutAttributeRight, inset),
    ]];
}
