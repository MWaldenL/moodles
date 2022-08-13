import Foundation
import ReSwift
import ReSwiftThunk
import Alamofire


extension EntryThunk {
    static func getEntries(
        by timePeriod: EntryTimePeriod,
        startDay: Date?,
        endDay: Date?) -> Thunk<AppState>
    {
        return Thunk<AppState> { dispatch, getState in
            guard let state = getState() else { return }
            
            let url = Api.Entry.URL_ENTRY_USER
            let formatter = ISO8601DateFormatter()
            formatter.timeZone = TimeZone(abbreviation: "GMT+8:00")
            let encoder = URLEncodedFormParameterEncoder(
                encoder: URLEncodedFormEncoder(
                dateEncoding: .iso8601))
            
            // Make the request
            var params: [String: Date]?
            if let startDay = startDay, let endDay = endDay {
                params = ["datefrom": startDay, "dateto": endDay]
            }
            AF.request(
                url,
                method: .get,
                parameters: params, // ["datefrom": startDay, "dateto": endDay],
                encoder: encoder,
                headers: ["Authorization": state.authState.token]
            ).responseData { res in
                switch res.result {
                case .success:
                    if let data = res.data {
                        do {
                            let rawEntryResponse = try JSONDecoder()
                                .decode(RawEntryResponse.self, from: data)
                            
                            // Set the current entries
                            let entries = rawEntryResponse.entries.map { entry in
                                _Entry(
                                    id: entry._id,
                                    dateCreated: DateService.toISOFormat(entry.dateCreated),
                                    dateUpdated: DateService.toISOFormat(entry.dateUpdated),
                                    moodLevel: entry.moodLevel,
                                    note: entry.note
                                )
                            }
                            dispatch(ActionSetCurrentEntries(currentEntries: entries))

                            // Set entries for time period
                            switch timePeriod {
                            case .day:
                                dispatch(ActionFilterByDay(
                                    day: state.entryState.currentDay))
                            case .week:
                                print(">>> EntryThunk during dispatch", state.entryState.currentWeek)
                                dispatch(ActionFilterByWeek(
                                    week: state.entryState.currentWeek))
                            case .month:
                                dispatch(ActionFilterByMonth(
                                    monthIndex: state.entryState.currentMonth))
                            case .all:
                                dispatch(ActionFilterAll())
                            }
                            
                            // Get tags for each entry
                            entries.forEach { entry in
                                dispatch(
                                    TagThunk.getTagsByEntryId(
                                        entryId: entry.id))
                            }
                        } catch(let error) {
                            print(">>> GetEntries (from success): ")
                            print(error)
                        }
                    }
                case .failure(let err):
                    print(">>> GetEntries: ")
                    print(err)
                }
            }
        }
    }
}
