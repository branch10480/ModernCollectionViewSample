import UIKit

public class SelectedTagCollectionView: UICollectionView {
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
        collectionViewLayout = createLayout()
        configureDataSrouce()
    }
}

private extension SelectedTagCollectionView {
    func setupData(data: [Tag]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Tag>()
        snapshot.appendSections([.main])
        snapshot.appendItems(data)
        diffableDataSource.apply(snapshot)
    }

    func createLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .estimated(50), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(widthDimension: .estimated(50), heightDimension: .absolute(44))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])

        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = .init(top: 16, leading: 16, bottom: 16, trailing: 16)
        section.interGroupSpacing = 16

        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.scrollDirection = .horizontal

        return UICollectionViewCompositionalLayout(section: section, configuration: config)
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
