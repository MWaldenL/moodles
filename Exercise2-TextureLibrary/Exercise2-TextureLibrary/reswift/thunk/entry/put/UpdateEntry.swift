import Foundation
import ReSwiftThunk
import Alamofire

//- MARK: Update entry
extension EntryThunk {
    static func updateEntry() -> Thunk<AppState> {
        return Thunk<AppState> { dispatch, getState in
            guard let state = getState() else { return }
            
            let entryId = store.state.entryState.currentEntryId
            let currentEntry = store.state.entryState.newEntryRequest
            let url = "http://localhost:8000/entries/edit/\(state.authState.userId)/\(entryId)"
            let newEntryRequest = state.entryState.newEntryRequest
            
            // Form the entry body
            let entryBody = RawUpdateEntryBody(
                datecreated: DateService.toISOStringFormat(currentEntry.date),
                moodLevel: Int(currentEntry.moodLevel),
                note: currentEntry.note,
                tags: currentEntry.tags.map { tag in
                    RawUpdateEntryBody.TagRequest(
                        tagName: tag.tagName,
                        fromUserTags: tag.fromUserTags)
                },
                removedTags: currentEntry.removedTags.map { tag in
                    RawUpdateEntryBody.TagRequest(
                        tagName: tag.tagName,
                        fromUserTags: tag.fromUserTags)
                })
            
            // Make the request
            AF.request(
                url,
                method: .put,
                parameters: entryBody,
                encoder: JSONParameterEncoder.default,
                headers: ["Authorization": state.authState.token ]
            ).responseData { res in
                let statusCode = res.response?.statusCode
                switch statusCode {
                case 200:
                    if let data = res.data {
                        do {
                            let entryResponse = try JSONDecoder()
                                .decode(RawEntryPostResponse.self, from: data)

                            // Form the updated entry
                            let updatedEntry = _Entry(
                                id: entryId,
                                dateCreated: DateService.toISOFormat(entryBody.datecreated),
                                dateUpdated: DateService.toISOFormat(entryBody.datecreated),
                                moodLevel: Int(entryBody.moodLevel),
                                note: entryBody.note,
                                tags: Set(entryBody.tags.map { TagEntry(tagName: $0.tagName) })
                            )
                            
                            // Get merged tags
                            let mergedTags = getMergedTags(state: state, entryResponse: entryResponse, entryObj: updatedEntry)
                            
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

                            // Update the entry in the store
                            dispatch(ActionSetEntryId(id: entryId)) // just in case
                            print(">>> UpdateEntry", updatedEntry)
                            dispatch(ActionUpdateEntry(updatedEntry: updatedEntry))
                        } catch(let err) {
                            print(err)
                        }
                    }
                default:
                    print(">>> failure")
                }
            }
        }
    }
}
