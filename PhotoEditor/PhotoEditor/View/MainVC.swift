//
//  HomeVC.swift
//  PhotoEditor
//
//  Created by Alexandr Filovets on 4.06.24.
//

import SnapKit
import UIKit

final class MainVC: UIViewController {
    let viewModel = MainViewModel()
    let filterControl = UISegmentedControl(items: ["Original", "Black&White"])
    
    private let imageViewLogo: UIImageView = {
        let imageViewLogo = UIImageView(frame: CGRect(x: 0, y: 0, width: 150, height: 150))
        imageViewLogo.image = UIImage(named: "logo")
        return imageViewLogo
    }()

    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    private let addButton: UIButton = {
        let button = UIButton(type: .system)
        let image = UIImage(systemName: "plus", withConfiguration: UIImage.SymbolConfiguration(pointSize: 40, weight: .bold, scale: .large))
        button.setImage(image, for: .normal)
        button.tintColor = .systemPurple
        button.backgroundColor = .white
        button.contentHorizontalAlignment = .center
        button.contentVerticalAlignment = .center
        button.addTarget(self, action: #selector(openPhotoLibrary), for: .touchUpInside)

        button.layer.cornerRadius = 40
        button.layer.masksToBounds = true

        return button
    }()
    
    private let frameView: UIView = {
        let view = UIView()
        view.layer.borderWidth = 2
        view.layer.borderColor = UIColor.yellow.cgColor
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupBindings()
        setupNavigationBar()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        imageViewLogo.center = view.center
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.animate()
        }
    }
    
    private func animate() {
        UIView.animate(withDuration: 1, animations: {
            let size = self.view.frame.size.width * 3
            let diffX = size - self.view.frame.size.width
            let diffY = self.view.frame.size.height - size
            
            self.imageViewLogo.frame = CGRect(
                x: -(diffX/2),
                y: diffY/2,
                width: size,
                height: size
            )
            UIView.animate(withDuration: 1.5, animations: {
                self.imageViewLogo.alpha = 0
            })
        })
    }
    
    private func setupUI() {
        view.backgroundColor = .gray
        view.addSubview(frameView)
        view.addSubview(addButton)
        frameView.addSubview(imageView)
        view.addSubview(imageViewLogo)
        
        addButton.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.height.equalTo(80)
        }
        
        frameView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(20)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-40)
            make.left.equalTo(view.safeAreaLayoutGuide.snp.left).offset(20)
            make.right.equalTo(view.safeAreaLayoutGuide.snp.right).offset(-20)
        }
        
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        frameView.clipsToBounds = true
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
        imageView.addGestureRecognizer(panGesture)
        
        let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(handlePinch))
        imageView.addGestureRecognizer(pinchGesture)
        
        let rotateGesture = UIRotationGestureRecognizer(target: self, action: #selector(handleRotate))
        imageView.addGestureRecognizer(rotateGesture)
    }
    
    private func setupBindings() {
        viewModel.image.bind { [weak self] image in
            guard let self = self else { return }
            if let image = image {
                self.imageView.image = image
                self.addButton.isHidden = true
            } else {
                self.imageView.image = nil
                self.addButton.isHidden = false
            }
        }
    }
    
    private var cancelButton: UIBarButtonItem?
    private var saveButton: UIBarButtonItem?

    private func setupNavigationBar() {
        navigationController?.navigationBar.backgroundColor = .mainWhite
        navigationController?.navigationBar.layer.cornerRadius = 16.0
        navigationController?.navigationBar.clipsToBounds = true
        
        filterControl.isUserInteractionEnabled = false
        filterControl.selectedSegmentIndex = 0
        filterControl.addTarget(self, action: #selector(filterChanged), for: .valueChanged)
        filterControl.setTitleTextAttributes([.foregroundColor: UIColor.tabBarItemLight], for: .normal)
        filterControl.setTitleTextAttributes([.foregroundColor: UIColor.tabBarItemAccent], for: .selected)
        filterControl.backgroundColor = UIColor.mainWhite
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: filterControl)

        cancelButton = UIBarButtonItem(image: UIImage(systemName: "trash"), style: .plain, target: self, action: #selector(resetEditor))
        cancelButton?.tintColor = .tabBarItemAccent
       
        saveButton = UIBarButtonItem(image: UIImage(systemName: "square.and.arrow.down"), style: .plain, target: self, action: #selector(saveImage))
        saveButton?.tintColor = .tabBarItemAccent

        if let cancelButton = cancelButton, let saveButton = saveButton {
            navigationItem.rightBarButtonItems = [saveButton, cancelButton]
        }
    }
    
    @objc private func openPhotoLibrary() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
    
    @objc private func filterChanged(sender: UISegmentedControl) {
        viewModel.applyFilter(index: sender.selectedSegmentIndex)
    }
    
    @objc private func saveImage() {
        // Решает проблему сохранения "ничего"
        guard let imageToSave = imageView.image else { return }

        // Сохраняем текущее состояние рамки
        let originalBorderWidth = frameView.layer.borderWidth
        let originalBorderColor = frameView.layer.borderColor

        // Временно убираем рамку
        frameView.layer.borderWidth = 0
        frameView.layer.borderColor = UIColor.clear.cgColor

        // Создаем изображение без рамки
        let renderer = UIGraphicsImageRenderer(bounds: frameView.bounds)
        let renderedImage = renderer.image { _ in
            frameView.drawHierarchy(in: frameView.bounds, afterScreenUpdates: true)
        }

        // Восстанавливаем рамку
        frameView.layer.borderWidth = originalBorderWidth
        frameView.layer.borderColor = originalBorderColor

        // Сохраняем изображение
        UIImageWriteToSavedPhotosAlbum(renderedImage, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
    }
    
    @objc private func handlePan(gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: view)
        imageView.center = CGPoint(x: imageView.center.x + translation.x, y: imageView.center.y + translation.y)
        gesture.setTranslation(.zero, in: view)
    }
    
    @objc private func handlePinch(gesture: UIPinchGestureRecognizer) {
        imageView.transform = imageView.transform.scaledBy(x: gesture.scale, y: gesture.scale)
        gesture.scale = 1
    }
    
    @objc private func handleRotate(gesture: UIRotationGestureRecognizer) {
        imageView.transform = imageView.transform.rotated(by: gesture.rotation)
        gesture.rotation = 0
    }
    
    @objc private func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        let ac = UIAlertController(title: error == nil ? "Saved!" : "Save error", message: error?.localizedDescription ?? "Your edited image has been saved.", preferredStyle: .alert)
        present(ac, animated: true)
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            ac.dismiss(animated: true)
            self.resetEditor()
        }
    }
    
    @objc private func resetEditor() {
        viewModel.originalImage = nil
        viewModel.originalColorImage = nil
        imageView.image = nil
        viewModel.image.value = nil
        addButton.isHidden = false
        filterControl.selectedSegmentIndex = 0
        filterControl.isUserInteractionEnabled = false
    }
}
