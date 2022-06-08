//
//  PlaceViewController.swift
//  favplaces
//
//  Created by Serhii Dvornyk on 08.06.2022.
//

import UIKit

class PlaceViewController: UIViewController {
    
    private let viewModel: PlaceViewModel
    
    let placeView = PlaceView()
    
    var imageIsChanged = false
    var incomeIdentifier = ""
    
    init(viewModel: PlaceViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - UIViewController lifecycle
    
    override func loadView() {
        view = placeView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupDelegate()
        setupInterface()
        tapOnImage()
        
        self.navigationItem.rightBarButtonItem?.isEnabled = false
        placeView.mapButton.isHidden = true
        
        setupEditScreen()
    }
    
    //MARK: - Business logic
    
    @objc func saveButtonTapped() {
        
        let image = imageIsChanged ? placeView.placeImage.image : UIImage(named: "emptyImage")
        
        viewModel.savePlace(name: placeView.placeNameTextField.text!,
                            location: placeView.placeLocationTextField.text,
                            type: placeView.placeTypeTextField.text,
                            image: image!,
                            rating: placeView.ratingControlStackView.rating)
        
        if incomeIdentifier == "addPlace" {
            self.navigationController?.popViewController(animated: true)
        } else {
            self.navigationController?.dismiss(animated: true)
        }
    }
    
    @objc func cancelButtonTapped() {
        self.dismiss(animated: true)
    }
    
    @objc func showPlaceOnMapTapped() {
        let mapVC = MapScreenViewController(viewModel: self.viewModel.getMapScreenViewModel())
        mapVC.incomeIdentifier = "showPlace"
        
        self.present(mapVC, animated: true)
    }
    
    @objc func getAddressTapped() {
        let mapVC = MapScreenViewController(viewModel: self.viewModel.getMapScreenViewModel())
        mapVC.incomeIdentifier = "getAddress"
        self.present(mapVC, animated: true)
    }
    
    private func tapOnImage() {
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self,
                                                          action: #selector(setImage))
        placeView.placeImage.isUserInteractionEnabled = true
        placeView.placeImage.addGestureRecognizer(tapGestureRecognizer)
    }
    
    func setupEditScreen() {
        
        viewModel.getCurrentPlace()
        
        if viewModel.currentPlace != nil {
            
            setupEditNavigationBar()
            imageIsChanged = true
            
            guard let imageData = viewModel.currentPlace?.imageData, let image = UIImage(data: imageData) else { return }
            
            placeView.mapButton.isHidden = false
            placeView.placeImage.image = image
            placeView.placeImage.contentMode = .scaleAspectFill
            placeView.placeNameTextField.text = viewModel.currentPlace?.name
            placeView.placeLocationTextField.text = viewModel.currentPlace?.location
            placeView.placeTypeTextField.text = viewModel.currentPlace?.type
            placeView.ratingControlStackView.rating = viewModel.currentPlace?.rating ?? 0.0
        }
    }
}

//MARK: - Setup interface

extension PlaceViewController {
    
    private func setupInterface() {
        
        title = "New place"
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveButtonTapped))
        self.navigationItem.rightBarButtonItem?.tintColor = UIColor(named: "firstColor")
        
        placeView.placeNameTextField.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
        placeView.mapButton.addTarget(self, action: #selector(showPlaceOnMapTapped), for: .touchUpInside)
        
        placeView.locationButton.addTarget(self, action: #selector(getAddressTapped), for: .touchUpInside)
        
    }
    
    private func setupEditNavigationBar() {
        
        title = viewModel.currentPlace?.name
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.rightBarButtonItem?.isEnabled = true
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelButtonTapped))
        self.navigationItem.leftBarButtonItem?.tintColor = UIColor(named: "firstColor")
        
    }
}

extension PlaceViewController {
    
    private func registerKeybordNotification() {
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keybordWillShow),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keybordWillHide),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
    }
    
    private func removeKeybordNotification() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc private func keybordWillShow(notification: Notification) {
        let userInfo = notification.userInfo
        let keybordHeight = (userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        placeView.scrollView.contentOffset = CGPoint(x: 0, y: keybordHeight.height / 2)
    }
    
    @objc private func keybordWillHide() {
        placeView.scrollView.contentOffset = CGPoint.zero
    }
}
