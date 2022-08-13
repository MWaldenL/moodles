import Foundation
import ReSwift


func tagReducer(action: Action, state: TagState?) -> TagState {
    var tagState = state ?? TagState()
    
    switch action {
        
    case let action as ActionUpdateTag:
        // Update the general tags
        if var currentTag = tagState.allTagSet.first(where: { $0.tagName == action.oldName }) {
            currentTag.tagName = action.newName
        }
        
        // Update the tag requests
        tagState.userTagRequests = tagState.userTagRequests.filter { $0.tagName != action.oldName }
        tagState.userTagRequests.update(
            with: TagRequest(
                tagName: action.newName,
                oldTagName: action.oldName,
                fromUserTags: true))
        
    case let action as ActionDeleteTag:
        tagState.userTagRequests = tagState.userTagRequests.filter {
            $0.tagName != action.name
        }
        tagState.allTagSet = tagState.allTagSet.filter {
            $0.tagName != action.name
        }
        
    case let action as ActionSetAllTags:
        tagState.allTagSet = action.tagSet
        
    case let action as ActionMergeToAllTags:
        tagState.allTagSet = tagState.allTagSet.union(action.tagSet)
        
    case let action as ActionMergeUserTagRequests:
        tagState.userTagRequests = tagState.userTagRequests.union(action.tagSet)
        
    default:
        break
    }
    
    return tagState
}
