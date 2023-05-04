import UIKit

public class TagCollectionView: UICollectionView {
    public var didSelectTag: ((Tag) -> Void)?
    public var didDeselectTag: ((Tag) -> Void)?

    private var diffableDataSource: UICollectionViewDiffableDataSource<Section, Tag>!

    private enum Section {
        case main
    }

    public var data: NSOrderedSet = NSOrderedSet(array: []) {
        didSet {
            setupData(data: data.array as? [Tag] ?? [])
        }
    }

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        allowsMultipleSelection = true
        delegate = self
        collectionViewLayout = createLayout()
        configureDataSrouce()
    }
}

private extension TagCollectionView {
    func setupData(data: [Tag]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Tag>()
        snapshot.appendSections([.main])
        snapshot.appendItems(data)
        diffableDataSource.apply(snapshot)
    }

    func createLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .estimated(50), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(44))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        group.interItemSpacing = .fixed(16)

        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = .init(top: 16, leading: 16, bottom: 16, trailing: 16)
        section.interGroupSpacing = 16

        return UICollectionViewCompositionalLayout(section: section)
    }

    func configureDataSrouce() {
        let cellRegistration = UICollectionView.CellRegistration<TagCell, Tag>(cellNib: .init(nibName: String(describing: TagCell.self), bundle: Bundle.module)) { cell, indexPath, itemIdentifier in
            cell.configure(tag: itemIdentifier)
        }

        diffableDataSource = .init(collectionView: self, cellProvider: { collectionView, indexPath, itemIdentifier in
            let cell = collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: itemIdentifier)
            return cell
        })
    }
}

extension TagCollectionView: UICollectionViewDelegate {
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let tag = diffableDataSource.snapshot().itemIdentifiers[indexPath.row]
        didSelectTag?(tag)
    }

    public func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let tag = diffableDataSource.snapshot().itemIdentifiers[indexPath.row]
        didDeselectTag?(tag)
    }
}
