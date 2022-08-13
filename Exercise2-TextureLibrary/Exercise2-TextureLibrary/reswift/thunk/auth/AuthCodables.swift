import Foundation


struct LoginBody: Encodable {
    let email: String
    let password: String
}

struct RegisterBody: Encodable {
    let email: String
    let name: String
    let password: String
    let confirmPassword: String
}

struct AuthSuccessResponse: Decodable {
    let token: String
    let userId: String
}
