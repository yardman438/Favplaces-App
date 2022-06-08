//
//  PlaceView.swift
//  favplaces
//
//  Created by Serhii Dvornyk on 08.06.2022.
//

import UIKit
import SnapKit

class PlaceView: UIView {
    
    //MARK: - Init elements
    
    let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.isScrollEnabled = true
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    let contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let placeImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "addImage")
        imageView.backgroundColor = .systemGray6
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let mapButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "map"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let placeNameLabel: UILabel = {
        let label = UILabel()
        label.text = "Name"
        label.font = .systemFont(ofSize: 20, weight: .regular)
        label.textColor = UIColor(named: "firstColor")
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let placeNameTextField: UITextField = {
        let textfield = UITextField()
        textfield.placeholder = "Name this place"
        textfield.borderStyle = .none
        textfield.returnKeyType = .done
        textfield.translatesAutoresizingMaskIntoConstraints = false
        return textfield
    }()
    
    let placeLocationLabel: UILabel = {
        let label = UILabel()
        label.text = "Location"
        label.font = .systemFont(ofSize: 20, weight: .regular)
        label.textColor = UIColor(named: "firstColor")
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let placeLocationTextField: UITextField = {
        let textfield = UITextField()
        textfield.placeholder = "Set the location"
        textfield.borderStyle = .none
        textfield.returnKeyType = .done
        textfield.translatesAutoresizingMaskIntoConstraints = false
        return textfield
    }()
    
    let locationButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "pinGetAddress"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let placeTypeLabel: UILabel = {
        let label = UILabel()
        label.text = "Type"
        label.font = .systemFont(ofSize: 20, weight: .regular)
        label.textColor = UIColor(named: "firstColor")
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let placeTypeTextField: UITextField = {
        let textfield = UITextField()
        textfield.placeholder = "Set the type of place"
        textfield.borderStyle = .none
        textfield.returnKeyType = .done
        textfield.translatesAutoresizingMaskIntoConstraints = false
        return textfield
    }()
    
    var placeNameStackView = UIStackView()
    var locationStackView = UIStackView()
    var placeLocationStackView = UIStackView()
    var placeTypeStackView = UIStackView()
    let ratingControlStackView = RatingControl()
    var mainStackView = UIStackView()
    
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
        
        //Setup stack views
        
        placeNameStackView = UIStackView(arrangedSubviews: [placeNameLabel, placeNameTextField], axis: .vertical, spacing: 2, distribution: .fillProportionally)
        
        locationStackView = UIStackView(arrangedSubviews: [placeLocationTextField, locationButton], axis: .horizontal, spacing: 8, distribution: .fillProportionally)
        placeLocationStackView = UIStackView(arrangedSubviews: [placeLocationLabel, locationStackView], axis: .vertical, spacing: 2, distribution: .fillProportionally)
        
        placeTypeStackView = UIStackView(arrangedSubviews: [placeTypeLabel, placeTypeTextField], axis: .vertical, spacing: 2, distribution: .fillProportionally)
        
        mainStackView = UIStackView(arrangedSubviews: [placeNameStackView, placeLocationStackView, placeTypeStackView], axis: .vertical, spacing: 24, distribution: .fillProportionally)
        
        // Create subviews
        
        self.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(placeImage)
        contentView.addSubview(mapButton)
        contentView.addSubview(mainStackView)
        contentView.addSubview(ratingControlStackView)
        
        // Create constraints for elements
        
        scrollView.snp.makeConstraints { make in
            make.top.leading.bottom.trailing.equalToSuperview()
        }
        
        contentView.snp.makeConstraints { make in
            make.top.leading.bottom.trailing.equalTo(scrollView)
            make.width.height.equalTo(scrollView)
        }
        
        placeImage.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(contentView)
            make.height.equalTo(350)
        }
        
        mapButton.snp.makeConstraints { make in
            make.height.width.equalTo(50)
            make.bottom.trailing.equalTo(placeImage).inset(20)
        }
        
        placeNameTextField.snp.makeConstraints { make in
            make.height.equalTo(30)
        }
        
        placeLocationTextField.snp.makeConstraints { make in
            make.height.equalTo(40)
        }
        
        locationButton.snp.makeConstraints { make in
            make.height.width.equalTo(40)
        }
        
        placeTypeTextField.snp.makeConstraints { make in
            make.height.equalTo(30)
        }
        
        mainStackView.snp.makeConstraints { make in
            make.top.equalTo(placeImage.snp.bottom).offset(24)
            make.leading.equalTo(contentView).offset(20)
            make.trailing.equalTo(contentView).inset(20)
        }

        ratingControlStackView.snp.makeConstraints { make in
            make.top.equalTo(mainStackView.snp.bottom).offset(48)
            make.centerX.equalTo(contentView)
        }
    }
}
