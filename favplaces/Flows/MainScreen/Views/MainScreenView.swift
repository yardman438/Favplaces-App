//
//  MainScreenView.swift
//  favplaces
//
//  Created by Serhii Dvornyk on 08.06.2022.
//

import UIKit
import SnapKit

class MainScreenView: UIView {
        
    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(MainScreenTableViewCell.self, forCellReuseIdentifier: MainScreenTableViewCell.identifier)
        tableView.separatorStyle = .none
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
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
        
        self.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(self.safeAreaLayoutGuide)
            make.bottom.equalToSuperview()
        }
    }
}
