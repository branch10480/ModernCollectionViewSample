import UIKit
import Combine

public class RootViewController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!

    private var cancellables = Set<AnyCancellable>()

    private enum Section {
        case main
    }

    private var data: [Tag] = []
    private var dataSource: UICollectionViewDiffableDataSource<Section, Tag>!

    public override func viewDidLoad() {
        super.viewDidLoad()
        setup()

        // Initial display
        search(keyword: nil)
    }
}

private extension RootViewController {
    func setup() {
        setObserver()
        collectionView.collectionViewLayout = createLayout()
        configureDataSrouce()
        setupData()
    }

    func setObserver() {
        searchBar.delegate = self
    }

    func setupData() {
        data = Array<Int>(0..<94).map{ Tag(id: $0.description, name: $0.description) }
    }

    func createLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .estimated(5), heightDimension: .fractionalHeight(1.0))
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

        dataSource = .init(collectionView: collectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            let cell = collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: itemIdentifier)
            return cell
        })
    }

    func search(keyword: String?) {
        var result = data
        if let keyword, !keyword.isEmpty {
            result = data.filter { $0.name.contains(keyword) }
        }

        var snapshot = NSDiffableDataSourceSnapshot<Section, Tag>()
        snapshot.appendSections([.main])
        snapshot.appendItems(result)
        dataSource.apply(snapshot)
    }
}

// MARK: - UISearchBarDelegate
extension RootViewController: UISearchBarDelegate {
    public func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        search(keyword: searchText)
    }

    public func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}
