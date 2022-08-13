import Foundation
import ReSwiftThunk

struct EntryThunk {
    static func getMergedTags(state: AppState, entryResponse: RawEntryPostResponse, entryObj: _Entry) -> Set<Tag> {
        // Get new tags
        let newTags = Set(state.entryState.newEntryRequest.tags
            .filter { tag in !tag.fromUserTags }
            .map { tag in
                Tag(
                    id: "",
                    userId: state.authState.userId,
                    entryIdSet: [
                        entryResponse._id: Float(entryResponse.moodLevel)
                    ],
                    tagName: tag.tagName,
                    datesLogged: [entryObj.dateCreated],
                    selected: false)
            })
        print(">>> Create entry new tags", newTags.map{ $0.tagName })
        
        
        // Add the entry to the existing tags w/ mood
        var existingTags = Array(state.entryState.newEntryRequest.tags
            .filter { tag in tag.fromUserTags }
            .map { tag in
                Tag(
                    id: "",
                    userId: state.authState.userId,
                    entryIdSet: [
                        entryResponse._id: Float(entryResponse.moodLevel)
                    ],
                    tagName: tag.tagName,
                    datesLogged: [entryObj.dateCreated],
                    selected: false)
            })
        print(">>> Create entry existing tags", existingTags.map{ $0.tagName })
        
        // Set the mood level to the entry set
        for (i, _) in existingTags.enumerated() {
            existingTags[i].entryIdSet[entryResponse._id] = Float(entryResponse.moodLevel)
        }
        
        // Merge all tags again
        let mergedTags = Set(existingTags).union(newTags).union(state.tagState.allTagSet)

        return mergedTags
    }
}
