const mongoose = require("mongoose")
const ObjectId = require("mongodb").ObjectId

const entrySchema = new mongoose.Schema({
    userId: {
        type: ObjectId,
        ref: "User",
        required: true
    },

    dateCreated: {
        type: Date,
        required: true
    },

    dateUpdated: {
        type: Date
    },

    moodLevel: {
        type: Number,
        default: 3,
        min: 1,
        max: 5,
        required: true
    },

    note: {
        type: String,
        minLength: 0,
        default: "",
        required: true
    }
})

module.exports = mongoose.model("Entry", entrySchema)
