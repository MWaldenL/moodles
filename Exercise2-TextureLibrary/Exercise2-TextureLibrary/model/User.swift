import Foundation

struct UserData: Codable {
    let _id: String
    let email: String
    let password: String
//    let name: String?
    let entryList: [String]
    let tagList: [String]
}

struct UserLoginData: Codable {
    let email: String
    let password: String
}

struct User: Codable {
    let id: String
    let email: String
    let name: String
}
