const mongoose = require("mongoose")
const ObjectId = require("mongodb").ObjectId

const userSchema = new mongoose.Schema({
    email: {
        type: String,
        trim: true,
        unique: true,
        match: [
            /^\w+([\.-]?\w+)*@\w+([\.-]?\w+)*(\.\w{2,3})+$/, 
            'Please fill a valid email address'
        ],
        required: 'Email address is required.'
    },
    password: {
        type: String,
        minLength: 8,
        maxLength: 255,
        match: [
            new RegExp("^(?=.*[a-z])(?=.*[A-Z])(?=.*[0-9])(?=.*[!@#\$%\^&\*])(?=.{8,})"),
            'Password must have at least eight characters, one lowercase letter, one uppercase letter, one number, and one special character.'
        ],
        trim: true,
        required: true
    },
    name: {
        type: String,
        minLength: 2,
        maxLength: 255,
        trim: true
    }
})

module.exports = mongoose.model("User", userSchema)
