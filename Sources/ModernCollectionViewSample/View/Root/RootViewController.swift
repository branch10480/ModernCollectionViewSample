import UIKit
import Combine

public class RootViewController: UIViewController {
    @IBOutlet weak var collectionView: TagCollectionView!
    @IBOutlet weak var collectionViewForSelectedTags: SelectedTagCollectionView!
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
        setupData()
    }

    func setObserver() {
        searchBar.delegate = self

        collectionView.didSelectTag = { [weak self] tag in
            guard let self else { return }
            let data = NSMutableOrderedSet(orderedSet: collectionViewForSelectedTags.data)
            data.add(tag)
            collectionViewForSelectedTags.data = data
        }

        collectionView.didDeselectTag = { [weak self] tag in
            guard let self else { return }
            let data = NSMutableOrderedSet(orderedSet: collectionViewForSelectedTags.data)
            data.remove(tag)
            collectionViewForSelectedTags.data = data
        }
    }

    func setupData() {
        data = Array<Int>(0..<94).map{ Tag(id: $0.description, name: $0.description) }
    }

    func search(keyword: String?) {
        var result = data
        if let keyword, !keyword.isEmpty {
            result = data.filter { $0.name.contains(keyword) }
        }

        collectionView.data = NSOrderedSet(array: result)
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
