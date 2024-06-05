//
//  Observable.swift
//  PhotoEditor
//
//  Created by Alexandr Filovets on 4.06.24.
//

import Foundation

// Класс для создания наблюдаемых объектов, который позволяет другим объектам подписываться на изменения и получать уведомления, когда значение меняется

class Observable<T> {
    // текущее значение наблюдаемого объекта, если меняется вызывается didSet, который уведомит о новом значении
    var value: T? {
        didSet {
            listener?(value)
        }
    }

    // замыкаение которое будет вызвано при изменении value
    private var listener: ((T?) -> Void)?

    init(_ value: T?) {
        self.value = value
    }

    // метод который и позволяет подписаться на изменения нашего значения, принимает наше замыкание при изменении value
    func bind(_ listener: @escaping (T?) -> Void) {
        self.listener = listener
        listener(value)
    }
}
