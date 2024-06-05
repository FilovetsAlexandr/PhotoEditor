//
//  MainVCExtension.swift
//  PhotoEditor
//
//  Created by Alexandr Filovets on 4.06.24.
//

import UIKit

// Расширение, чтобы после выбора пользователем изображение мы обновляли наше значение "image" во ViewModel
extension MainVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        if let selectedImage = info[.originalImage] as? UIImage {
            viewModel.image.value = selectedImage
            viewModel.setImage(selectedImage)
        }
        // Разрешаем взаимодействие c сегментами
        filterControl.isUserInteractionEnabled = true
        // Закрываем галерею
        dismiss(animated: true, completion: nil)
    }
}
