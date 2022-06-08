//
//  MainScreenTableViewCell.swift
//  favplaces
//
//  Created by Serhii Dvornyk on 08.06.2022.
//

import UIKit
import SnapKit

class MainScreenTableViewCell: UITableViewCell {
    
    static let identifier = "MainScreenTableViewCell"
    
    //MARK: - Elements & properties
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .medium)
        label.textColor = UIColor(named: "secondColor")
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let locationLabel: UILabel = {
        let label = UILabel()
        label.text = "Location"
        label.font = .systemFont(ofSize: 16, weight: .light)
        label.textColor = UIColor(named: "thirdColor")
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let typeLabel: UILabel = {
        let label = UILabel()
        label.text = "Type"
        label.font = .systemFont(ofSize: 12, weight: .light)
        label.textColor = UIColor(named: "thirdColor")
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let imageOfPlace: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 12
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let ratingStarImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "filledStar")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let ratingLabel: UILabel = {
        let label = UILabel()
        label.text = "5.0"
        label.font = .systemFont(ofSize: 12, weight: .light)
        label.textColor = UIColor(named: "thirdColor")
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var mainStackView = UIStackView()
    var ratingStackView = UIStackView()
    var typeRatingStackView = UIStackView()
    
    //MARK: - Lifecycle
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCellView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Setup method
    
    private func setupCellView() {
        
        self.addSubview(imageOfPlace)
        imageOfPlace.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(4)
            make.leading.equalToSuperview().offset(20)
            make.bottom.equalToSuperview().inset(4)
            make.height.width.equalTo(84)
        }
        
        ratingStarImage.snp.makeConstraints { make in
            make.height.width.equalTo(16)
        }
        
        ratingStackView = UIStackView(arrangedSubviews: [ratingStarImage, ratingLabel], axis: .horizontal, spacing: 3, distribution: .fill)
        
        typeRatingStackView = UIStackView(arrangedSubviews: [typeLabel, ratingStackView], axis: .horizontal, spacing: 9, distribution: .fill)
        typeRatingStackView.alignment = .leading
        
        mainStackView = UIStackView(arrangedSubviews: [nameLabel, locationLabel, typeRatingStackView], axis: .vertical, spacing: 6, distribution: .fillEqually)
        self.addSubview(mainStackView)
        mainStackView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(12)
            make.leading.equalTo(imageOfPlace.snp.trailing).offset(12)
            make.bottom.equalToSuperview().inset(12)
            make.trailing.equalToSuperview().inset(22)
        }
    }
}
