let createError = require('http-errors');
let express = require('express');
let path = require('path');
let cookieParser = require('cookie-parser');
let logger = require('morgan');

let authMiddleware = require('./middleware/auth')

let usersRouter = require('./routes/users');
let entriesRouter = require('./routes/entries');
let tagsRouter = require('./routes/tags');
let authRouter = require('./routes/auth');

let app = express();

// Mongoose
const mongoose = require("mongoose")
const dbUrl = 'mongodb://localhost:27017/mood-tracker'
mongoose.connect(dbUrl, { useNewUrlParser: true })
    .then(() => console.log('Connected to MongoDB!'))
    .catch(err => console.log('Could not connect to MongoDB.\n' + err));

// view engine setup
app.set('views', path.join(__dirname, 'views'));
app.set('view engine', 'jade');

app.use(logger('dev'));
app.use(express.json());
app.use(express.urlencoded({ extended: false }));
app.use(cookieParser());
app.use(express.static(path.join(__dirname, 'public')));

app.use('/auth', authRouter);
app.use('/users', authMiddleware, usersRouter);
app.use('/entries', authMiddleware, entriesRouter);
app.use('/tags', authMiddleware, tagsRouter);

// catch 404 and forward to error handler
app.use(function(req, res, next) {
  next(createError(404));
});

// error handler
app.use(function(err, req, res, next) {
  // set locals, only providing error in development
  res.locals.message = err.message;
  res.locals.error = req.app.get('env') === 'development' ? err : {};
});

app.listen(8000, () => { console.log("Listening on port 8000") })

module.exports = app;
