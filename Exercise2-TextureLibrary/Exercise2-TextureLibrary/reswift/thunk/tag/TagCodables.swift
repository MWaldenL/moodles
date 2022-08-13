import Foundation


struct RawTagResponse: Decodable {
    let tags: [TagResponse]
    struct TagResponse: Decodable {
        let _id: String
        let userIdSet: [String: Bool]
        let entryIdSet: [String: Float]
        let tagName: String
        let datesLogged: [String]
    }
}

struct RawTagUpdateReq: Encodable {
    let name: String
}
