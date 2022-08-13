import Foundation
import ReSwift
import ReSwiftThunk
import Alamofire

//- MARK: Get tags by entry
extension TagThunk {
    static func getTagsByEntryId(entryId: String) -> Thunk<AppState> {
        return Thunk<AppState> { dispatch, getState in
            guard let state = getState() else { return }
            
            let url = "http://localhost:8000/tags/entry/\(entryId)"
            AF.request(
                url,
                method: .get,
                headers: ["Authorization": state.authState.token]
            ).responseData { res in
                switch res.result {
                case .success:
                    if let data = res.data {
                        do {
                            let rawTagResponse = try JSONDecoder()
                                .decode(RawTagResponse.self, from: data)
                            let tagList = rawTagResponse.tags.map { tag in
                                TagEntry(tagName: tag.tagName)
                            }
                            dispatch(
                                ActionSetEntryTags(
                                    forEntryId: entryId,
                                    tagList: Set(tagList)))
                        } catch {
                            print(error)
                        }
                    }
                case .failure(let err):
                    print(">>> GetTagsByEntryId: ")
                    print(err)
                    break
                }
            }
        }
    }
}
