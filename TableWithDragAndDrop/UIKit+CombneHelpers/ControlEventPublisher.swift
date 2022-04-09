//
//  ControlEventPublisher.swift
//  TableWithDragAndDrop
//
//  Created by Beniamin on 09.04.22.
//  from https://github.com/CombineCommunity/CombineCocoa/blob/f35362b30713a0f717106e45cd7e1b71d024c37e/Sources/CombineCocoa/Controls/UIControl%2BCombine.swift

import Combine
import UIKit

public extension UIControl {
    /// A publisher emitting events from this control.
    func controlEventPublisher(for events: UIControl.Event) -> AnyPublisher<Void, Never> {
        Publishers.ControlEvent(control: self, events: events)
                  .eraseToAnyPublisher()
    }
}
