//
//  CategoryCell.swift
//  DiffableDataSourceSample
//
//  Created by cmStudent on 2021/10/01.
//

import UIKit

class CategoryCell: UICollectionViewCell {
    
    let label = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupLabel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("not implemented")
    }
    
}

extension CategoryCell {
    
    private func setupLabel() {
        label.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(label)
        label.textColor     = .white
        label.textAlignment = .center
        label.adjustsFontForContentSizeCategory = true
        layer.cornerRadius = 10
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            label.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            label.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
    
}
