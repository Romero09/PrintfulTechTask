//
//  Binding.swift
//  PrintfulTechTask
//
//  Created by pavels.vetlugins on 08/11/2020.
//

import Foundation

class Binding<T> {
    typealias Listener = (T) -> Void
    var listener: Listener?

    var value: T{
        didSet {
            listener?(value)
        }
    }

    init(_ v: T) {
        value = v
    }

    func bindAndFire(listener: Listener?) {
        self.listener = listener
        listener?(value)
    }

    func bind(listener: Listener?){
        self.listener = listener
    }
}
