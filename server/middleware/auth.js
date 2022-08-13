const config = require('config');
const jwt = require('jsonwebtoken');


module.exports = (req, res, next) => {
    const token = req.headers['authorization']
    if (!token) {
        return res.status(401).send("Authorization error. No token provided")
    }
    try {
        const decoded = jwt.verify(token, config.get("jwtPrivateKey"))
        req.user = decoded
        next()
    } catch(err) {
        console.log(err)
        res.status(401).send("Invalid auth token or token has expired.")
    }
}
