const mongoose = require('mongoose')
const db = require('../configuration/db')
const UserModel = require('./user.model')
const { Schema } = mongoose;

const todoSchema = new Schema({
    userId: {
        type: Schema.Types.ObjectId,
        ref: UserModel.modelName
    },
    title: {
        type: String,
        require: true
    },
    description: {
        type: String,
        require: true
    },
})

const TodoModel = db.model('todo', todoSchema);
module.exports = TodoModel;