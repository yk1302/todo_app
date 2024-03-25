const express = require('express');
const app = express()
const bodyParser = require('body-parser')
const userRoute = require('./routes/user.route')
const TodoRoute = require('./routes/todo.route')

app.use(bodyParser.json()) // support json encoded bodies
app.use('/', userRoute)
app.use('/', TodoRoute)
module.exports = app;