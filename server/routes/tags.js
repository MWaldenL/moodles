var express = require('express');
var router = express.Router();
const Tag = require("../models/Tag")

// Get tag by id
router.get('/tag/:tagId', (req, res) => {
    let tagId = req.params.tagId
    Tag.findById(tagId)
        .then(tag => res.status(200).send(tag))
        .catch(err => res.status(404).send("Tag not found with id " + tagId + err))
})

// Get user tags
router.get('/user/:userId', async (req, res) => {
    let userId = req.params.userId
    try {
        const tags = await Tag.find({
            [`userIdSet.${userId}`]: { $exists: true }
        })
        res.status(200).send({ tags })
    } catch(err) {
        res.status(404).send(err)
    }
})

// Get tag by entry id 
router.get('/entry/:entryId', async (req, res) => {
    let entryId = req.params.entryId
    console.log(">>> entryid:", entryId)
    try {
        const tags = await Tag.find({ 
            [`entryIdSet.${entryId}`]: { $exists: true }
        })
        res.status(200).send({ tags })
    } catch (err) {
        res.status(404).send(err)
    }
})

// Update tag by id
// router.put('/:tagId', (req, res) => {
//     let tagId = req.params.tagId
//     let newTagName = req.body.name
//     Tag.updateOne({ _id: tagId }, { name: newTagName })
//         .then(tag => res.status(200).send(tag))
// })

// Update tag by name
router.put('/:tagName', async (req, res) => {
    let tagName = req.params.tagName
    let newTagName = req.body.name
    try {
        let updatedTag = await Tag.updateOne({ tagName }, { tagName: newTagName })
        res.status(200).send(updatedTag)
    } catch(err) {
        console.log(err)
        res.status(500).send("Unable to update tag")
    }
})

// Delete tag
router.delete('/:tagName', async (req, res) => {
    let tagName = req.params.tagName
    try {
        await Tag.deleteOne({ tagName })
        res.status(200).send(`Successfully deleted tag ${tagName}`)
    } catch (err) {
        res.status(500).send(`Unable to delete tag ${tagName}, ${err}`)
    }
})

module.exports = router