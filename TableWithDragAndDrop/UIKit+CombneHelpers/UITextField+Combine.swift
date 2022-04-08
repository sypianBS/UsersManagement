//
//  UITextField+Combine.swift
//  TableWithDragAndDrop
//
//  Created by Beniamin on 08.04.22.
//  based on https://github.com/CombineCommunity/CombineCocoa/blob/main/Sources/CombineCocoa/Controls/UITextField%2BCombine.swift

import Foundation
import Combine
import UIKit

public extension UITextField {
    /// A publisher emitting any text changes to a this text field.
    var textPublisher: AnyPublisher<String?, Never> {
        Publishers.ControlProperty(control: self, events: .defaultValueEvents, keyPath: \.text)
                  .eraseToAnyPublisher()
    }
}
