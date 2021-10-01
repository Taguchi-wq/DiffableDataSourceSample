//
//  ViewController.swift
//  DiffableDataSourceSample
//
//  Created by cmStudent on 2021/09/29.
//

import UIKit

class ViewController: UIViewController {
    
    // MARK: - Enums
    private enum Section: CaseIterable {
        case category
        case main
    }
    
    
    // MARK: - @IBOutlets
    @IBOutlet private weak var collectionView: UICollectionView!
    
    
    // MARK: - Properties
    private var categories: [Category] = []
    private var products: [Product] = []
    private var dataSource: UICollectionViewDiffableDataSource<Section, AnyHashable>! = nil
    
    
    // MARK: - Override Funcs
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCollectionView(collectionView)
        setupDataSource()
        appendProducts()
        appendCategory()
        performQuery()
    }
    
    
    // MARK: - Private Funcs
    private func appendProducts() {
        products = [
            Product(name: "イス"),
            Product(name: "テーブル"),
            Product(name: "テーブル"),
            Product(name: "ソファ"),
            Product(name: "カーペット"),
            Product(name: "カーテン"),
            Product(name: "タンス"),
            Product(name: "イス"),
            Product(name: "テーブル"),
            Product(name: "ソファ"),
            Product(name: "カーペット"),
            Product(name: "カーテン"),
            Product(name: "タンス"),
            Product(name: "イス"),
            Product(name: "テーブル"),
            Product(name: "ソファ"),
            Product(name: "カーペット"),
            Product(name: "カーテン"),
            Product(name: "タンス"),
            Product(name: "カーペット"),
            Product(name: "イス"),
            Product(name: "タンス"),
            Product(name: "テーブル"),
            Product(name: "タンス"),
        ]
    }
    
    private func appendCategory() {
        categories = [
            Category(name: "すべて"),
            Category(name: "イス"),
            Category(name: "テーブル"),
            Category(name: "ソファ"),
            Category(name: "カーペット"),
            Category(name: "タンス")
        ]
    }
    
    private func setupCollectionView(_ collectionView: UICollectionView) {
        collectionView.delegate = self
        collectionView.collectionViewLayout = createLayout()
    }
    
}


// MARK: - DataSource
extension ViewController {
    
    private func setupDataSource() {
        let categoryCell = UICollectionView.CellRegistration<CategoryCell, Category> {
            (cell, indexPath, category) in
            cell.label.text = category.name
            cell.backgroundColor = .systemBlue
        }
        
        let productCell = UICollectionView.CellRegistration<ProductCell, Product> {
            (cell, indexPath, product) in
            cell.label.text = product.name
            cell.backgroundColor = .systemRed
        }
        
        dataSource = UICollectionViewDiffableDataSource<Section, AnyHashable>(collectionView: collectionView) {
            (collectionView, indexPath, item) -> UICollectionViewCell? in
            if let category = item as? Category {
                return collectionView.dequeueConfiguredReusableCell(using: categoryCell, for: indexPath, item: category)
            }
            
            if let product = item as? Product {
                return collectionView.dequeueConfiguredReusableCell(using: productCell, for: indexPath, item: product)
            }
            
            return nil
        }
    }
    
    private func performQuery() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, AnyHashable>()
        snapshot.appendSections([.category, .main])
        snapshot.appendItems(categories, toSection: .category)
        snapshot.appendItems(products, toSection: .main)
        dataSource.apply(snapshot, animatingDifferences: true)
    }
    
    private func performFilterQuery(with filter: String) {
        var filterProducts: [Product] = []
        if filter == "すべて" {
            filterProducts = products
        } else {
            filterProducts = products.filter { $0.name == filter }
        }
        
        var snapshot = NSDiffableDataSourceSnapshot<Section, AnyHashable>()
        snapshot.appendSections([.category, .main])
        snapshot.appendItems(categories, toSection: .category)
        snapshot.appendItems(filterProducts, toSection: .main)
        dataSource.apply(snapshot, animatingDifferences: true)
    }
    
}


// MARK: - Layout
extension ViewController {
    
    private func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout {
            (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            let section = Section.allCases[sectionIndex]
            switch section {
            case .category: return self.createCategorySectionLayout()
            case .main:     return self.createMainSectionLayout()
            }
        }
        
        return layout
    }
    
    private func createCategorySectionLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .estimated(1),
            heightDimension: .fractionalHeight(1)
        )
        
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .estimated(1),
            heightDimension: .fractionalHeight(1/20)
        )
        
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitems: [item]
        )
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        section.interGroupSpacing = 10
        section.contentInsets = .init(top: 20, leading: 10, bottom: 10, trailing: 10)
        
        return section
    }

    private func createMainSectionLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .fractionalHeight(1)
        )
        
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = .init(top: 0, leading: 5, bottom: 0, trailing: 5)

        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .fractionalHeight(0.4)
        )
        
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitem: item,
            count: 2
        )

        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 10
        section.contentInsets = .init(top: 10, leading: 5, bottom: 20, trailing: 5)

        return section
    }
    
}


// MARK: - UICollectionViewDelegate
extension ViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let category = dataSource.itemIdentifier(for: indexPath) as? Category {
            performFilterQuery(with: category.name)
        }
    }
    
}
