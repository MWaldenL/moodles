import Foundation


struct RawEntryBody: Encodable {
    let datecreated: String
    let moodLevel: Int
    let note: String
    let tags: [TagRequest]
    
    struct TagRequest: Encodable {
        let tagName: String
        let fromUserTags: Bool
    }
}

struct RawUpdateEntryBody: Encodable {
    let datecreated: String
    let moodLevel: Int
    let note: String
    let tags: [TagRequest]
    let removedTags: [TagRequest]
    
    struct TagRequest: Encodable {
        let tagName: String
        let fromUserTags: Bool
    }
}

struct RawEntryPostResponse: Decodable {
    let _id: String
    let userId: String
    let dateCreated: String
    let dateUpdated: String
    let moodLevel: Int
    let note: String
}
