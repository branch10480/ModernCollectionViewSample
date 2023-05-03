import Foundation

public struct Tag: Hashable {
    public var id: String
    public var name: String

    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
