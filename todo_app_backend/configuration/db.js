const mongoose = require('mongoose');

const connection = mongoose.createConnection('mongodb://localhost/todoApp').on('open', () => {
    console.log("connection established with mongodb")
}).on('error', () => {
    console.log("Error occur while connecting to mongodb...")
});

module.exports = connection;