import Foundation
import Alamofire


struct TokenService {
    static func getAuthToken() -> String {
        if let cookieStorage = AF.session.configuration.httpCookieStorage {
            if let token = cookieStorage.cookies?.first(where: { $0.name == "token" }) {
                return token.value
            }
        }
        return ""
    }
    
    static func getUserId(fromToken token: String) -> String {
        do {
            let payload = try decodeAuthToken(withToken: token)
            return payload["id"] as! String
        } catch(let error) {
            print(error)
            return ""
        }
    }
    
    static func clearAuthToken() {
        if let cookieStorage = AF.session.configuration.httpCookieStorage {
            if let token = cookieStorage.cookies?.first(where: { $0.name == "token" }) {
                cookieStorage.deleteCookie(token)
            }
        }
    }
    
    static func writeTokenToCookies(token: String) {
        let tokenCookie = HTTPCookie(
            properties: [
                .domain: "/",
                .name: "token",
                .value: token,
                .path: "/",
                .expires: DateService.createDate(
                    year: 2022, month: 8, day: 10,
                    hour: 12, minute: 0)
            ])
        if let tokenCookie = tokenCookie {
            AF.session
                .configuration
                .httpCookieStorage?
                .setCookie(tokenCookie)
        }
    }
    
    private static func decodeAuthToken(withToken token: String) throws -> [String: Any] {
        enum DecodeError: Error {
            case decodeError
            case other
        }
        
        func base64Decode(_ base64: String) throws -> Data {
            let base64 = base64
                .replacingOccurrences(of: "-", with: "+")
                .replacingOccurrences(of: "_", with: "/")
            
            let len = Double(base64.count)
            let padded = base64.padding(
                toLength: (Int(ceil(len / 4)) * 4),
                withPad: "=",
                startingAt: 0)
            
            guard let decoded = Data(base64Encoded: padded) else {
                throw DecodeError.decodeError
            }
            return decoded
        }
        
        func decodeJWTPart(_ value: String) throws -> [String: Any] {
            let body = try base64Decode(value)
            let json = try JSONSerialization.jsonObject(with: body)
            guard let payload = json as? [String: Any] else {
                throw DecodeError.other
            }
            return payload
        }
        
        let tokens = token.components(separatedBy: ".")
        if tokens[0].isEmpty {
            return [:]
        }
        return try decodeJWTPart(tokens[1])
    }
}
