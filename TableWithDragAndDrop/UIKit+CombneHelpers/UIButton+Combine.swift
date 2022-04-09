//
//  UIButton+Combine.swift
//  TableWithDragAndDrop
//
//  Created by Beniamin on 09.04.22.
//  from https://github.com/CombineCommunity/CombineCocoa/blob/f35362b30713a0f717106e45cd7e1b71d024c37e/Sources/CombineCocoa/Controls/UIButton%2BCombine.swift

import Combine
import UIKit

public extension UIButton {
    /// A publisher emitting tap events from this button.
    var tapPublisher: AnyPublisher<Void, Never> {
        controlEventPublisher(for: .touchUpInside)
    }
}
