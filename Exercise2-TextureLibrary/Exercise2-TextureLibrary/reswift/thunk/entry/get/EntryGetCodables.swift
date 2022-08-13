import Foundation


struct RawEntryResponse: Decodable {
    let entries: [EntryResponse]
    
    struct EntryResponse: Decodable {
        let _id: String
        let dateCreated: String
        let dateUpdated: String
        let moodLevel: Int
        let note: String
        let userId: String
    }
}
