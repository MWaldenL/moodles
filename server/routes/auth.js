var express = require('express');
var router = express.Router();
const User = require("../models/User")
const bcrypt = require("bcrypt")
const config = require("config")
const jwt = require('jsonwebtoken');


// Register user
router.post('/register', async (req, res) => {
    let { email, password, confirmPassword, name } = req.body

    // Check if passwords match
    if (password !== confirmPassword) {
        res.status(400).send("Passwords don't match.") // 400?
        return
    }

    // Check if there is an existing user in the database
    try {
        let existingUser = await User.findOne({ email: req.body.email })
        if (existingUser) {
            res.status(409).send('This email is already registered.')
        } else {
            try {
                // Create a new user with the given email
                const newUser = new User({ email, password, name })

                // Hash the password
                const salt = await bcrypt.genSalt(10)
                newUser.password = await bcrypt.hash(newUser.password, salt)

                // Save the user
                await newUser.save()

                // Sign a token
                jwt.sign({ id: newUser._id }, config.get("jwtPrivateKey"),
                    (err, token) => {
                        res.cookie('token', token)
                        if (err) {
                            console.log(err)
                            throw err
                        } else {
                            res.status(200).json({ token, userId: newUser._id })
                        }
                    })
            } catch(err) {
                console.log(err)
                res.status(500).send(err)
            }
        }
    } catch(err) {
        console.log(err)
        res.status(500).send("Unable to create user")
    }
});

// Login user
router.post('/login', async (req, res) => {
    let email = req.body.email
    let password = req.body.password
    try {
        const user = await User.findOne({ email: email }) // check if the email exists
        const passMatch = await bcrypt.compare(password, user.password)
        if (passMatch) {
            jwt.sign({ id: user._id }, config.get("jwtPrivateKey"),
                (err, token) => {
                    res.cookie('token', token)
                    if (err) {
                        console.log(err)
                        throw err
                    } else {
                        res.status(200).json({ token, userId: user._id })
                    }
                })
        } else {
            console.log(err)
            res.status(400).send("Email or password is incorrect")
        }
    } catch(err) {
        console.log(err)
        res.status(400).send("Email or password is incorrect")
    }
})

module.exports = router;