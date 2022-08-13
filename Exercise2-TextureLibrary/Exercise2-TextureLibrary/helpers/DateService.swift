import Foundation


struct DateService {
    // Basic
    static func day(_ date: Date) -> String {
        return date.formatted(date: .numeric, time: .omitted)
    }
    
    static func dayNum(_ date: Date) -> Int {
        let dateString = day(date)
        return Int(dateString.split(separator: "/")[1])!
    }
    
    static func year(_ date: Date) -> Int {
        let cal = Calendar.current.dateComponents([.day, .year, .month], from: date)
        return cal.year ?? 2022
    }
    
    static func month(_ date: Date) -> Int {
        let cal = Calendar.current.dateComponents([.day, .year, .month], from: date)
        return cal.month ?? 1
    }
    
    static func week(_ date: Date) -> Week {
        let day = dayNum(date)
        
        // Compute start day
        var startDay = 1
        if day <= 28 {
            if day % 7 == 0 {
                startDay = day - 6
            } else {
                startDay = 7 * (day / 7) + 1
            }
        } else {
            startDay = 28
        }
        
        let nDays = daysInMonth(month: month(date), year: year(date))
        let endDay = min(startDay + 6, nDays) // mod number of days

        return Week(month: month(date), startDay: startDay, endDay: endDay)
    }
    
    
    // Strings
    static func monthString(month: Int) -> String {
        return Constants.MONTHS[month]
    }
    
    static func weekString(month: Int, startDay: Int, endDay: Int) -> String {
        return "\(Constants.MONTHS[month]) \(startDay) - \(endDay)"
    }
    
    static func weekString(week: Week) -> String {
        return "\(Constants.MONTHS[week.month]) \(week.startDay) - \(week.endDay)"
    }
    
    
    // Currents
    static func getCurrentDay() -> Int {
        return dayNum(Date())
    }
    
    static func getCurrentWeek() -> Week {
        return week(Date())
    }
    
    static func getPreviousWeek() -> Week {
        let lastWeek = Date() - (60 * 60 * 24 * 7)
        return week(lastWeek)
    }
    
    static func getCurrentMonth() -> Int {
        return month(Date())
    }
    
    
    // Create
    static func createDate(year: Int, month: Int, day: Int, hour: Int, minute: Int) -> Date {
        var dateComponents = DateComponents()
        dateComponents.year = year
        dateComponents.month = month
        dateComponents.day = day
        dateComponents.hour = hour
        dateComponents.minute = minute

        // Create date from components
        let cal = Calendar(identifier: .gregorian)
        let date = cal.date(from: dateComponents)
        return date ?? Date()
    }
    
    static func toISOFormat(_ dateStr: String) -> Date {
        let fmt = ISO8601DateFormatter()
        fmt.timeZone = .current //TimeZone.init(identifier: "Asia/Manila")
        return fmt.date(
            from: String(dateStr.split(separator: ".")[0]) + String("Z")) ?? Date()
    }
    
    static func toISOStringFormat(_ date: Date) -> String {
        let fmt = ISO8601DateFormatter()
        return fmt.string(from: date)
    }
    
    // Utilities
    static func daysInMonth(month: Int, year: Int) -> Int {
        let dateComponents = DateComponents(year: year, month: month)
        let calendar = Calendar.current
        let date = calendar.date(from: dateComponents)!

        let range = calendar.range(of: .day, in: .month, for: date)!
        let numDays = range.count
        return numDays
    }
}
