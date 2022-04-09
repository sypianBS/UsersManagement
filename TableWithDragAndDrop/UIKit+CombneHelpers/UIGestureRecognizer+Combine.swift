//
//  UIGestureRecognizer+Combine.swift
//  TableWithDragAndDrop
//
//  Created by Beniamin on 09.04.22.
//  from https://github.com/CombineCommunity/CombineCocoa/blob/main/Sources/CombineCocoa/Controls/UIGestureRecognizer%2BCombine.swift

import Combine
import UIKit

// MARK: - Gesture Publishers
@available(iOS 13.0, *)
public extension UITapGestureRecognizer {
    /// A publisher which emits when this Tap Gesture Recognizer is triggered
    var tapPublisher: AnyPublisher<UITapGestureRecognizer, Never> {
        gesturePublisher(for: self)
    }
}

// A private generic helper function which returns the provided
// generic publisher whenever its specific event occurs.
private func gesturePublisher<Gesture: UIGestureRecognizer>(for gesture: Gesture) -> AnyPublisher<Gesture, Never> {
    Publishers.ControlTarget(control: gesture,
                             addTargetAction: { gesture, target, action in
                                gesture.addTarget(target, action: action)
                             },
                             removeTargetAction: { gesture, target, action in
                                gesture?.removeTarget(target, action: action)
                             })
              .subscribe(on: DispatchQueue.main)
              .map { gesture }
              .eraseToAnyPublisher()
}
