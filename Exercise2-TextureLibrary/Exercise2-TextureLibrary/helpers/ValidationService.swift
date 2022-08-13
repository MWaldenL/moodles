import Foundation


enum RegistrationErrors {
    case fieldsEmpty
    case emailInvalid
    case weakPassword
    case passwordMismatch
}

struct ValidationService {
    static func validate(fields: [String: String]) -> [RegistrationErrors: String] {
        let fieldsNotEmpty = validateFieldsNotEmpty(fields)
        let emailValid = validateEmail(fields["email"])
        let strongPassword = validatePass(fields["password"])
        let passwordsMatch = fields["password"] == fields["confirmPassword"]
        var result: [RegistrationErrors: String] = [:]
        
        if !fieldsNotEmpty {
            result[.fieldsEmpty] = "No field must be empty."
        }
        if !emailValid {
            result[.emailInvalid] = "Please input a valid email."
        }
        if !strongPassword {
            result[.weakPassword] =
                "Password must have at least eight characters, one lowercase letter, one uppercase letter, one number, and one special character."
        }
        if !passwordsMatch {
            result[.passwordMismatch] = "Passwords must match."
        }
        
        return result
    }
    
    static func validateFieldsNotEmpty(_ fields: [String: String]) -> Bool {
        var isValid = true
        fields.forEach { field in
            isValid = isValid && !field.value.isEmpty
        }
        return isValid
    }
    
    static func validateEmail(_ email: String?) -> Bool {
        guard let email = email else { return false }
        let re = "^[\\p{L}0-9!#$%&'*+\\/=?^_`{|}~-][\\p{L}0-9.!#$%&'*+\\/=?^_`{|}~-]{0,63}@[\\p{L}0-9-]+(?:\\.[\\p{L}0-9-]{2,7})*$"
        let pred = NSPredicate(format: "SELF MATCHES %@", re)
        return pred.evaluate(with: email)
    }
    
    static func validatePass(_ pass: String?) -> Bool {
        guard let pass = pass else { return false }
        let re = "^(?=.*[A-Z])(?=.*[!@#$&*])(?=.*[0-9])(?=.*[a-z]).{8,}$"
        let pred = NSPredicate(format: "SELF MATCHES %@", re)
        return pred.evaluate(with: pass)
    }
}
//Helloworld1!
