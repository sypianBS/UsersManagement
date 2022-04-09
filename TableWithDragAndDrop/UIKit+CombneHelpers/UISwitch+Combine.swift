//
//  UISwitch+Combine.swift
//  TableWithDragAndDrop
//
//  Created by Beniamin on 09.04.22.
//

import Combine
import UIKit

public extension UISwitch {
    /// A publisher emitting on status changes for this switch.
    var isOnPublisher: AnyPublisher<Bool, Never> {
        Publishers.ControlProperty(control: self, events: .defaultValueEvents, keyPath: \.isOn)
                  .eraseToAnyPublisher()
    }
}
