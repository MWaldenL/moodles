var express = require('express');
var router = express.Router();
const Entry = require("../models/Entry")
const Tag = require("../models/Tag")
const ObjectId = require("mongodb").ObjectId

// Get entries by user id and date
router.get('/:userId', async (req, res) => {
    let dateFrom = req.query.datefrom
    let dateTo = req.query.dateto
    let userId = req.params.userId
    let shouldIncludeDate = typeof(dateFrom) != 'undefined' && typeof(dateTo) != 'undefined'
    try {
        if (shouldIncludeDate) {
            dateFrom = new Date(dateFrom.split('T')[0])
            dateTo = new Date(new Date(dateTo.split('T')[0]).getTime() + (24 * 60 * 60 * 1000))
            const entries = await Entry.find({
                userId,
                $and: [
                    { dateUpdated: { $gte: dateFrom } },
                    { dateUpdated: { $lt: dateTo } }
                ]
            })
            res.status(200).send({ entries })
        } else {
            const entries = await Entry.find({ userId })
            res.status(200).send({ entries })
        }    
    } catch(err) {
        res.status(404).send(err)
    }
})

// Get entry by id
router.get('/entry/:entryId', (req, res) => {
    let entryId = req.params.entryId
    Entry.findOne(entryId)
        .then(entry => res.send(entry))
})

// New Entry
router.post('/new/:userId', async (req, res) => {
    // Create the tags array
    let userId = req.params.userId
    let dateCreated = req.body.datecreated
    let moodLevel = parseInt(req.body.moodLevel)
    let note = req.body.note
    let tagRequests = req.body.tags

console.log(moodLevel)

    // First update the tags collection or create new tags
    let newEntryId = ObjectId()
    tagRequests = tagRequests.map(tag => {
        if (tag.fromUserTags) { // Update the tag's entry and user lists
            return Tag.updateOne(
                { "tagName": tag.tagName }, 
                { 
                    $push: {
                        datesLogged: dateCreated
                    },
                    $set: {
                        [`entryIdSet.${newEntryId}`]: moodLevel,
                        [`userIdSet.${userId}`]: true
                    }
                }).exec()
        } else { // Create a new tag with mood and current date
            return new Tag({ 
                tagName: tag.tagName,
                datesLogged: [dateCreated],
                entryIdSet: { [`${newEntryId}`]: moodLevel },
                userIdSet: { [`${userId}`]: true }
            }).save()
        }
    })

    Promise.all(tagRequests)

    // Create the new entry 
    const newEntry = await new Entry({ 
        _id: newEntryId,
        userId, 
        dateCreated, 
        dateUpdated: dateCreated, 
        moodLevel, 
        note
    }).save()

    res.send(newEntry)
})

// Update entry
router.put('/edit/:userId/:entryId', async (req, res) => {
    // Create the tags array
    let entryId = req.params.entryId
    let userId = req.params.userId
    let dateCreated = req.body.datecreated
    let moodLevel = parseInt(req.body.moodLevel)
    let note = req.body.note
    let tagRequests = req.body.tags
    let removedTags = req.body.removedTags

    // Create the updated entries
    try {
        let updatedEntry = await Entry.findByIdAndUpdate(
            { _id: entryId },
            { 
                $set: {
                    dateCreated,
                    dateUpdated: Date(), // set it to now
                    moodLevel: moodLevel,
                    note: note
                }
            },
            { new: true, lean: true },
        )

        // Update existing or create new tags
        tagRequests = tagRequests.map(tag => {
            if (tag.fromUserTags) { // Update the tag's entry and user lists
                return Tag.updateOne(
                    { "tagName": tag.tagName }, 
                    { 
                        $set: { 
                            [`entryIdSet.${entryId}`]: moodLevel, // Object Ids
                            [`userIdSet.${userId}`]: true
                        }
                    }).exec()
            } else { // Create a new tag with mood and current date
                return new Tag({ 
                    tagName: tag.tagName,
                    datesLogged: [dateCreated],
                    entryIdSet: { [`${entryId}`]: moodLevel },
                    userIdSet: { [`${userId}`]: true }
                }).save()
            }
        })
        Promise.all(tagRequests).then(tags => console.log(tags))

        // Update removed tags to no longer include this entry
        removedTags = removedTags.map(removedTag => {
            return Tag.updateOne(
                { "tagName": removedTag.tagName },
                { 
                    $unset: {
                        [`entryIdSet.${entryId}`]: 1
                    }
                }
            ).exec()
        })
        Promise.all(removedTags).then(oldTags => console.log(oldTags))

        res.status(200).send(updatedEntry)
    } catch(err) {
        console.log(err)
        res.status(500).send(err)
    }
})

// Delete entry
router.delete('/:entryId', async (req, res) => {
    let entryId = req.params.entryId
    try {
        // Select tags that contain this entry id
        let tagsWithEntry = await Tag.find(
            { [`entryIdSet.${entryId}`]: { $exists: true } }
        )

        // Remove the entry from its entry list
        tagsWithEntry = tagsWithEntry.map(tag => {
            return Tag.updateOne(
                { "tagName": tag.tagName },
                {
                    $unset: {
                        [`entryIdSet.${entryId}`]: 1
                    }
                }
            ).exec()
        })
        Promise.all(tagsWithEntry)

        // Then delete the entry
        let entry = await Entry.findByIdAndDelete(entryId)
        res.status(200).send("Deleted entry " + entryId)
    } catch(err) {
        console.log(err)
        res.status(500).send(err)
    } 
})

module.exports = router
