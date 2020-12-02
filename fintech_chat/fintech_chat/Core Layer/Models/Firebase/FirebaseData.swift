import Firebase

protocol IFirebaseInit {
    init?(_ data: QueryDocumentSnapshot)
}

struct FirebaseData<T: IFirebaseInit> {
    private(set) var added = [T]()
    private(set) var modified = [T]()
    private(set) var removed = [T]()
    
    init(documentChanges: [DocumentChange]) {
        for change in documentChanges {
            guard let element = T(change.document) else { continue }
            
            switch change.type {
            case .added:
                added.append(element)
            case .removed:
                removed.append(element)
            case .modified:
                modified.append(element)
            }
        }
    }
    
    init(added: [T], modified: [T], removed: [T]) {
        self.added = added
        self.modified = modified
        self.removed = removed
    }
}
