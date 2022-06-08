//
//  FilterSettingsViewController.swift
//  favplaces
//
//  Created by Serhii Dvornyk on 08.06.2022.
//

import UIKit
import SnapKit

class FilterSettingsViewController: UIViewController {
    
    lazy var filterControl: UISegmentedControl = {
        let segmentedControl = UISegmentedControl(items: ["Date", "Name"])
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        return segmentedControl
    }()
    
    lazy var sortingControl: UISegmentedControl = {
        let segmentedControl = UISegmentedControl(items: ["A-Z", "Z-A"])
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        return segmentedControl
    }()
    
    lazy var applyButton: UIButton = {
        let button = UIButton()
        button.setTitle("Apply", for: .normal)
        button.backgroundColor = UIColor(named: "firstColor")
        button.layer.cornerRadius = 8
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var cancelButton: UIButton = {
        let button = UIButton()
        button.setTitle("Cancel", for: .normal)
        button.setTitleColor(UIColor(named: "firstColor"), for: .normal)
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor(named: "firstColor")?.cgColor
        button.layer.cornerRadius = 8
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var buttonsStackView = UIStackView()
    lazy var contentStackView = UIStackView()
    
    lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 16
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let maxDimmedAlpha: CGFloat = 0.6
    lazy var dimmedView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.alpha = maxDimmedAlpha
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // Constants
    let defaultHeight: CGFloat = 400
    let dismissibleHeight: CGFloat = 200
    let maximumContainerHeight: CGFloat = 400
    var currentContainerHeight: CGFloat = 300
    
    var filterSegmentIndex = 0
    var sortSegmentIndex = 0
    
    // Dynamic container constraint
    var containerViewHeightConstraint: NSLayoutConstraint?
    var containerViewBottomConstraint: NSLayoutConstraint?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupPanGesture()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        animateShowDimmedView()
        animatePresentContainer()
    }
    
    @objc func handleCloseAction() {
        animateDismissView()
    }
    
    @objc func applyButtonTapped() {
        
        animateDismissView()
    }
    
    @objc func cancelButtonTapped() {
        animateDismissView()
    }
    
    @objc func filterSelection() {
        filterSegmentIndex = filterControl.selectedSegmentIndex
    }
    
    @objc func sortSelection() {
        sortSegmentIndex = sortingControl.selectedSegmentIndex
    }
    
    // MARK: Pan gesture handler
    @objc func handlePanGesture(gesture: UIPanGestureRecognizer) {
        
        let translation = gesture.translation(in: view)
        
        let isDraggingDown = translation.y > 0
        
        let newHeight = currentContainerHeight - translation.y
        
        switch gesture.state {
        case .changed:
            if newHeight < maximumContainerHeight {
                containerViewHeightConstraint?.constant = newHeight
                view.layoutIfNeeded()
            }
        case .ended:
            if newHeight < dismissibleHeight {
                self.animateDismissView()
            }
            else if newHeight < defaultHeight {
                animateContainerHeight(defaultHeight)
            }
            else if newHeight < maximumContainerHeight && isDraggingDown {
                animateContainerHeight(defaultHeight)
            }
            else if newHeight > defaultHeight && !isDraggingDown {
                animateContainerHeight(maximumContainerHeight)
            }
        default:
            break
        }
    }
    
    func setupPanGesture() {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(self.handlePanGesture(gesture:)))
        panGesture.delaysTouchesBegan = false
        panGesture.delaysTouchesEnded = false
        view.addGestureRecognizer(panGesture)
    }
}

// MARK: - Present and dismiss animation

extension FilterSettingsViewController {
    
    func animatePresentContainer() {

        UIView.animate(withDuration: 0.3) {
            self.containerViewBottomConstraint?.constant = 0
            self.view.layoutIfNeeded()
        }
    }
    
    func animateShowDimmedView() {
        
        dimmedView.alpha = 1
        UIView.animate(withDuration: 0.4) {
            self.dimmedView.alpha = self.maxDimmedAlpha
        }
    }
    
    func animateDismissView() {
        
        dimmedView.alpha = maxDimmedAlpha
        
        UIView.animate(withDuration: 0.4) {
            self.dimmedView.alpha = 1
        } completion: { _ in
            self.dismiss(animated: false)
        }
        
        UIView.animate(withDuration: 0.3) {
            self.containerViewBottomConstraint?.constant = self.defaultHeight
            self.view.layoutIfNeeded()
        }
    }
    
    func animateContainerHeight(_ height: CGFloat) {
        
        UIView.animate(withDuration: 0.4) {
            self.containerViewHeightConstraint?.constant = height
            self.view.layoutIfNeeded()
        }
        
        currentContainerHeight = height
    }
}

//MARK: - Setup Interface

extension FilterSettingsViewController {
    
    func setupView() {
        view.backgroundColor = .clear
        
        // tap gesture on dimmed view to dismiss
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.handleCloseAction))
        dimmedView.addGestureRecognizer(tapGesture)
        
        setupConstraints()
    }
    
    func setupConstraints() {
        view.addSubview(dimmedView)
        dimmedView.snp.makeConstraints { make in
            make.top.leading.bottom.trailing.equalToSuperview()
        }
        
        view.addSubview(containerView)
        containerView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
        }
        
        filterControl.snp.makeConstraints { make in
            make.height.equalTo(60)
        }
        sortingControl.snp.makeConstraints { make in
            make.height.equalTo(60)
        }
        applyButton.snp.makeConstraints { make in
            make.height.equalTo(60)
        }
        cancelButton.snp.makeConstraints { make in
            make.height.equalTo(60)
        }
        
        filterControl.addTarget(self, action: #selector(filterSelection), for: .valueChanged)
        sortingControl.addTarget(self, action: #selector(sortSelection), for: .valueChanged)
        applyButton.addTarget(self, action: #selector(applyButtonTapped), for: .touchUpInside)
        cancelButton.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
        
        buttonsStackView = UIStackView(arrangedSubviews: [applyButton, cancelButton],
                                       axis: .vertical,
                                       spacing: 4,
                                       distribution: .fillEqually)
        
        contentStackView = UIStackView(arrangedSubviews: [filterControl,
                                                          sortingControl,
                                                          buttonsStackView],
                                       axis: .vertical,
                                       spacing: 18,
                                       distribution: .fill)
        containerView.addSubview(contentStackView)
        contentStackView.snp.makeConstraints { make in
            make.top.equalTo(containerView.snp.top).offset(32)
            make.leading.equalTo(containerView.snp.leading).offset(20)
            make.trailing.equalTo(containerView.snp.trailing).inset(20)
        }
        
        containerViewHeightConstraint = containerView.heightAnchor.constraint(equalToConstant: defaultHeight)
        containerViewBottomConstraint = containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: defaultHeight)
        
        containerViewHeightConstraint?.isActive = true
        containerViewBottomConstraint?.isActive = true
    }
}
