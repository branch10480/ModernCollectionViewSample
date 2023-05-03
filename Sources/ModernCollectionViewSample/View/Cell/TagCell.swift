//
//  TagCell.swift
//  
//
//  Created by Toshiharu Imaeda on 2023/05/03.
//

import UIKit

public class TagCell: UICollectionViewCell {
    @IBOutlet weak var label: UILabel!

    public override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
}

public extension TagCell {
    func setup() {
        backgroundColor = .lightGray
        layer.cornerRadius = 5
        layer.masksToBounds = true
    }

    func configure(tag: Tag) {
        label.text = tag.name
    }
}
