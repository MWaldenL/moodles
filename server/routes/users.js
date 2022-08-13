var express = require('express');
var router = express.Router();
const User = require("../models/User")
const bcrypt = require("bcrypt")
const auth = require("../middleware/auth")
const config = require("config")
const jwt = require('jsonwebtoken');


// Get user by id
router.get('/:userId', auth, async (req, res) => {
    let userId = req.params.userId
    try {
        let user = await User.findById(userId)
        res.status(200).json({
            _id: user._id, email: user.email, name: user.name
        })
    } catch(err) {
        res.status(500).send(err)
    }
})

// Update user
router.put('/:userId', (req, res) => {
    let userId = req.params.userId
    User.updateOne(
        { _id: userId }, 
        { 
            $set: {
                email: req.body.email,
                password: req.body.password,
                name: req.body.name
            } 
        })
        .then(user => res.status(200).send(user))
        .catch(err => res.status(500).send(
            `Unable to update user ${userId} ${err}`))
})

// Delete user
router.delete('/:userId', (req, res) => {
    let userId = req.params.userId
    User.deleteOne({ _id: userId })
        .then(() => res.status(200).send('Successfully deleted user ' + userId))
        .catch(err => res.status(500).send('Unable to delete user ' + userId + ' ' + err))
})

module.exports = router;
