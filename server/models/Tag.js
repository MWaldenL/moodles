const mongoose = require("mongoose")
const ObjectId = require("mongodb").ObjectId

const tagSchema = new mongoose.Schema({
    tagName: {
        type: String,
        required: true
    },
    // moodList: { 
    //     type: Map, 
    //     of: Boolean
    // },
    datesLogged: [{ type: Date }],
    entryIdSet: {
        type: Map,
        of: Number
    },
    userIdSet: {
        type: Map,
        of: Boolean
    }
})

module.exports = mongoose.model('Tag', tagSchema)
