//
//  RootViewController.swift
//  
//
//  Created by Toshiharu Imaeda on 2023/05/03.
//

import UIKit

public class RootViewController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!

    private enum Section {
        case main
    }

    private var dataSource: UICollectionViewDiffableDataSource<Section, Tag>!

    public override func viewDidLoad() {
        super.viewDidLoad()

        setup()
    }
}

private extension RootViewController {
    func setup() {
        collectionView.collectionViewLayout = createLayout()
        configureDataSrouce()
        setupData()
    }

    func setupData() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Tag>()
        snapshot.appendSections([.main])
        snapshot.appendItems(Array<Int>(0..<94).map{ Tag(id: $0.description, name: $0.description) })
        dataSource.apply(snapshot)
    }

    func createLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.2), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = .init(top: 5, leading: 5, bottom: 5, trailing: 5)

        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalWidth(0.2))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])

        let section = NSCollectionLayoutSection(group: group)
        return UICollectionViewCompositionalLayout(section: section)
    }

    func configureDataSrouce() {
        let cellRegistration = UICollectionView.CellRegistration<TagCell, Tag>(cellNib: .init(nibName: String(describing: TagCell.self), bundle: Bundle.module)) { cell, indexPath, itemIdentifier in
            cell.configure(tag: itemIdentifier)
        }

        dataSource = .init(collectionView: collectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            let cell = collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: itemIdentifier)
            return cell
        })
    }
}
