//
//  RatingControl.swift
//  favplaces
//
//  Created by Serhii Dvornyk on 08.06.2022.
//

import UIKit
import SnapKit

class RatingControl: UIStackView {
    
    //MARK: - Properties
    
    var rating: Double = 0 {
        didSet {
            updateButtonSelectionState()
        }
    }
    
    private var ratingButtons = [UIButton]()
    
    //MARK: - Initialization

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButtons()
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
        setupButtons()
    }
    
    //MARK: - Methods
    
    @objc private func ratingButtonTapped(button: UIButton) {
        
        guard let index = ratingButtons.firstIndex(of: button) else { return }
        
        let selectedRating: Double = Double(index + 1)
        
        if selectedRating == rating {
            rating = 0
        } else {
            rating = selectedRating
        }
        
    }
    
    private func setupButtons() {
        
        let emptyStar = UIImage(named: "emptyStar")
        let filledStar = UIImage(named: "filledStar")
        let highlightedStar = UIImage(named: "highlightedStar")
        
        for _ in 0..<5 {
            
            let button: UIButton = {
                let button = UIButton()
                button.setImage(emptyStar, for: .normal)
                button.setImage(filledStar, for: .selected)
                button.setImage(highlightedStar, for: .highlighted)
                button.setImage(highlightedStar, for: [.highlighted, .selected])
                button.translatesAutoresizingMaskIntoConstraints = false
                return button
            }()
            
            button.addTarget(self, action: #selector(ratingButtonTapped), for: .touchUpInside)
            
            button.snp.makeConstraints { make in
                make.height.width.equalTo(44)
            }
            
            addArrangedSubview(button)
            
            ratingButtons.append(button)
        }
        
        spacing = 6
        distribution = .equalSpacing
        updateButtonSelectionState()
    }
    
    private func updateButtonSelectionState() {
        for (index, button) in ratingButtons.enumerated() {
            button.isSelected = Double(index) < rating
        }
    }
}
