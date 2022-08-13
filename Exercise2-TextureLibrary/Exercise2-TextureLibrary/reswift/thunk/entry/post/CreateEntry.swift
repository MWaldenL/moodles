import Foundation
import ReSwiftThunk
import Alamofire

//- MARK: Create new entry
extension EntryThunk {
    static func createNewEntry() -> Thunk<AppState> {
        return Thunk<AppState> { dispatch, getState in
            guard let state = getState() else { return }
            
            // Form the tag and entry bodies
            let url = "http://localhost:8000/entries/new/\(state.authState.userId)"
            let newEntryRequest = state.entryState.newEntryRequest
            print(">>> CreateEntry: ", newEntryRequest.moodLevel)
            let entryBody = RawEntryBody(
                datecreated: DateService.toISOStringFormat(newEntryRequest.date),
                moodLevel: Int(newEntryRequest.moodLevel),
                note: newEntryRequest.note.isEmpty ? "Type to add note" : newEntryRequest.note,
                tags: newEntryRequest.tags.map { tag in
                    RawEntryBody.TagRequest(
                        tagName: tag.tagName,
                        fromUserTags: tag.fromUserTags
                    )
                })
            
            // Make the request
            AF.request(
                url,
                method: .post,
                parameters: entryBody,
                encoder: JSONParameterEncoder.default,
                headers: ["Authorization": state.authState.token]
            ).responseData { res in
                let statusCode = res.response?.statusCode
                switch statusCode {
                case 200:
                    if let data = res.data {
                        do {
                            let entryResponse = try JSONDecoder()
                                .decode(RawEntryPostResponse.self, from: data)
                            
                            // Add entry to store
                            let newEntry = _Entry(
                                id: entryResponse._id,
                                dateCreated: DateService.toISOFormat(entryBody.datecreated),
                                dateUpdated: DateService.toISOFormat(entryBody.datecreated),
                                moodLevel: Int(entryBody.moodLevel),
                                note: entryBody.note,
                                tags: Set(newEntryRequest.tags.map { TagEntry(tagName: $0.tagName) })
                            )
                            dispatch(ActionAddEntry(newEntry: newEntry))
                            
                            // Set merged tags
                            let mergedTags = getMergedTags(
                                state: state,
                                entryResponse: entryResponse,
                                entryObj: newEntry)
                            print(">>> Create entry merged tags", mergedTags.map{ $0.tagName })
                            
                            // Set tags to store
                            dispatch(ActionSetAllTags(tagSet: mergedTags))
                            dispatch(ActionSetInsightTags(tagSet: mergedTags))
                            
                            // For showing in the recent tag cloud
                            let newUserTagRequests = Set(newEntryRequest.tags
                                .map { tag in
                                    TagRequest(
                                        tagName: tag.tagName,
                                        fromUserTags: true)
                                })
                            dispatch(ActionMergeUserTagRequests(tagSet: newUserTagRequests))
                        } catch {
                            print(error)
                        }
                    }
                default:
                    print(">>> error")
                    break
                }
            }
        }
    }
}
