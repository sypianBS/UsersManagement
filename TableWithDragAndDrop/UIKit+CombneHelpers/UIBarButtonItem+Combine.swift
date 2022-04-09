//
//  UIBarButtonItem+Combine.swift
//  TableWithDragAndDrop
//
//  Created by Beniamin on 09.04.22.
//  source https://github.com/CombineCommunity/CombineCocoa/blob/main/Sources/CombineCocoa/Controls/UIBarButtonItem%2BCombine.swift

import Combine
import UIKit

public extension UIBarButtonItem {
    /// A publisher which emits whenever this UIBarButtonItem is tapped.
    var tapPublisher: AnyPublisher<Void, Never> {
        Publishers.ControlTarget(control: self,
                                 addTargetAction: { control, target, action in
                                    control.target = target
                                    control.action = action
                                 },
                                 removeTargetAction: { control, _, _ in
                                    control?.target = nil
                                    control?.action = nil
                                 })
                  .eraseToAnyPublisher()
  }
}
