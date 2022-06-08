//
//  PlaceViewController + Extension.swift
//  favplaces
//
//  Created by Serhii Dvornyk on 08.06.2022.
//

import UIKit

extension PlaceViewController: UITextFieldDelegate {
    
    func setupDelegate() {
        placeView.placeNameTextField.delegate = self
        placeView.placeLocationTextField.delegate = self
        placeView.placeTypeTextField.delegate = self
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        placeView.placeNameTextField.resignFirstResponder()
        placeView.placeLocationTextField.resignFirstResponder()
        placeView.placeTypeTextField.resignFirstResponder()
        return true
    }
    
    @objc func textFieldChanged() {
        
        if placeView.placeNameTextField.text?.isEmpty == false {
            self.navigationItem.rightBarButtonItem?.isEnabled = true
        } else {
            self.navigationItem.rightBarButtonItem?.isEnabled = false
        }
    }
}

//MARK: - Setup image picker

extension PlaceViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @objc func setImage() {
        
        let cameraIcon = UIImage(named: "camera")
        let photoIcon = UIImage(named: "photoa")
        
        let alertSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let cameraAction = UIAlertAction(title: "Camera", style: .default) { _ in
            self.chooseImagePicker(source: .camera)
        }
        cameraAction.setValue(cameraIcon, forKey: "image")
        cameraAction.setValue(CATextLayerAlignmentMode.left, forKey: "titleTextAlignment")
        
        let photoAction = UIAlertAction(title: "Photo", style: .default) { _ in
            self.chooseImagePicker(source: .photoLibrary)
        }
        photoAction.setValue(photoIcon, forKey: "image")
        photoAction.setValue(CATextLayerAlignmentMode.left, forKey: "titleTextAlignment")
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        alertSheet.addAction(cameraAction)
        alertSheet.addAction(photoAction)
        alertSheet.addAction(cancelAction)
        
        present(alertSheet, animated: true)
        
    }

    func chooseImagePicker(source: UIImagePickerController.SourceType) {

        if UIImagePickerController.isSourceTypeAvailable(source) {

            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.allowsEditing = true
            imagePicker.sourceType = source
            present(imagePicker, animated: true)

        }
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {

        placeView.placeImage.image = info[.editedImage] as? UIImage
        placeView.placeImage.contentMode = .scaleAspectFill
        placeView.placeImage.clipsToBounds = true

        imageIsChanged = true

        dismiss(animated: true)

    }
}
