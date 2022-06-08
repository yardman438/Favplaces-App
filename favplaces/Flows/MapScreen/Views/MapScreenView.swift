//
//  MapScreenView.swift
//  favplaces
//
//  Created by Serhii Dvornyk on 08.06.2022.
//

import UIKit
import MapKit

class MapScreenView: UIView {

    let mapView: MKMapView = {
        let view = MKMapView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let currentPlaceLabel: UILabel = {
        let label = UILabel()
        label.text = "Place"
        label.numberOfLines = 2
        label.font = .systemFont(ofSize: 36, weight: .regular)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let cancelButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "cancel"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let pinImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "pin")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let doneButton: UIButton = {
        let button = UIButton()
        button.setTitle("Done", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 24, weight: .bold)
        button.setTitleColor(UIColor(named: "fourthColor"), for: .normal)
        button.backgroundColor = UIColor(named: "secondColor")
        button.layer.cornerRadius = 30
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let getDirectionButton: UIButton = {
        let button = UIButton()
        button.setTitle("Go", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 24, weight: .bold)
        button.setTitleColor(UIColor(named: "fourthColor"), for: .normal)
        button.backgroundColor = UIColor(named: "secondColor")
        button.layer.cornerRadius = 30
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let userLocationButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "navigation"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    //MARK: - UIView lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupInterface()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Setup interface
    
    private func setupInterface() {
        
        self.backgroundColor = .white
        createSubviews()
    }
    
    private func createSubviews() {
        
        self.addSubview(mapView)
        mapView.snp.makeConstraints { make in
            make.top.leading.bottom.trailing.equalToSuperview()
        }
        
        currentPlaceLabel.text = ""
        self.addSubview(currentPlaceLabel)
        currentPlaceLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(120)
            make.leading.equalToSuperview().offset(40)
            make.trailing.equalToSuperview().inset(40)
        }
        
        self.addSubview(cancelButton)
        cancelButton.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide).offset(40)
            make.trailing.equalTo(self.safeAreaLayoutGuide).inset(40)
            make.height.width.equalTo(30)
        }
        
        self.addSubview(pinImage)
        pinImage.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-20)
            make.height.width.equalTo(40)
        }
        
        self.addSubview(doneButton)
        doneButton.snp.makeConstraints { make in
            make.leading.equalTo(self.safeAreaLayoutGuide).offset(40)
            make.bottom.equalTo(self.safeAreaLayoutGuide).inset(40)
            make.height.equalTo(60)
            make.width.equalTo(250)
        }
        
        self.addSubview(getDirectionButton)
        getDirectionButton.snp.makeConstraints { make in
            make.leading.equalTo(self.safeAreaLayoutGuide).offset(40)
            make.bottom.equalTo(self.safeAreaLayoutGuide).inset(40)
            make.height.equalTo(60)
            make.width.equalTo(240)
        }
        
        self.addSubview(userLocationButton)
        userLocationButton.snp.makeConstraints { make in
            make.bottom.equalTo(self.safeAreaLayoutGuide).inset(40)
            make.trailing.equalTo(self.safeAreaLayoutGuide).inset(40)
            make.height.width.equalTo(60)
        }
    }
}
