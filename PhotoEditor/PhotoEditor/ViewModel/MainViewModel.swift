//
//  MainViewModel.swift
//  PhotoEditor
//
//  Created by Alexandr Filovets on 4.06.24.
//

import CoreImage
import UIKit

class MainViewModel {
    // Наблюдаемый объект
    var image: Observable<UIImage?> = Observable(nil)
    
    var originalImage: UIImage?
    var originalColorImage: UIImage?
    private let context = CIContext()
    
    func setImage(_ newImage: UIImage?) {
        originalImage = newImage
        image.value = newImage
    }
    
    func applyFilter(index: Int) {
        guard let originalImage = image.value else { return }
        
        let ciImage = CIImage(image: originalImage!)
        
        if index == 1 {
            // Сохраняем цветное изображение, если еще не сохранено
            if originalColorImage == nil {
                originalColorImage = originalImage
            }
            
            // Применяем черно-белый фильтр
            let filter = CIFilter(name: "CIPhotoEffectMono")
            filter?.setValue(ciImage, forKey: kCIInputImageKey)
            
            guard let outputImage = filter?.outputImage,
                  let cgImage = context.createCGImage(outputImage, from: outputImage.extent)
            else {
                image.value = originalImage
                return
            }
            
            image.value = UIImage(cgImage: cgImage)
        } else {
            // Восстанавливаем оригинальное цветное изображение
            if let colorImage = originalColorImage {
                image.value = colorImage
            } else {
                image.value = originalImage
            }
        }
    }
}
