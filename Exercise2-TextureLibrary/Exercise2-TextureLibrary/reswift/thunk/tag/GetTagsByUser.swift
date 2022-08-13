import Foundation
import ReSwift
import ReSwiftThunk
import Alamofire

//- MARK: Get tags by user
struct TagThunk {
    static func getTagsByUserId(_ userId: String) -> Thunk<AppState> {
        return Thunk<AppState> { dispatch, getState in
            guard let state = getState() else { return }
            
            let url = "http://localhost:8000/tags/user/\(userId)"
            AF.request(
                url,
                headers: ["Authorization": state.authState.token]
            ).responseData { res in
                switch res.result {
                case .success:
                    if let data = res.data {
                        do {
                            let rawTagResponse = try JSONDecoder()
                                .decode(RawTagResponse.self, from: data)
                            
                            // Create the full tag set
                            let tagList = rawTagResponse.tags.map { tag -> Tag in
                                let mappedDates = tag.datesLogged.map { dateStr in
                                    return DateService.toISOFormat(dateStr)
                                }
                                return Tag(
                                    id: tag._id,
                                    userId: userId,
                                    entryIdSet: tag.entryIdSet,
                                    tagName: tag.tagName,
                                    datesLogged: mappedDates
                                )
                            }
                            let tagSet = Set(tagList.map { $0 })
                            
                            // Create the reduced user tag request set
                            let userTagRequestSet = Set(tagList.map { tag in
                                TagRequest(tagName: tag.tagName, fromUserTags: true)
                            })
                            
                            // Dispatch
                            dispatch(
                                ActionSetInsightTags(
                                    tagSet: tagSet))
                            
                            dispatch(
                                ActionSetAllTags(
                                    tagSet: tagSet))
                            
                            dispatch(
                                ActionMergeUserTagRequests(
                                    tagSet: userTagRequestSet))
                            
                            dispatch(
                                ActionSetInsightsLoaded())
                        } catch {
                            print(error)
                        }
                    }
                case .failure(let err):
                    print(">>> GetTagsByUser: ")
                    print(err)
                    break
                }
            }
        }
    }
}
