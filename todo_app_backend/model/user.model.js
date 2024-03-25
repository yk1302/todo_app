const mongoose = require('mongoose')
const db = require('../configuration/db')
const validator = require('validator')
const { Schema } = mongoose;
const bcrypt = require('bcrypt')
const userSchema = new Schema({
    email: {
        type: String,
        require: true,
        lowercase: true,
        unique: [true, "Email Id is already present"],
        validate(value) {
            if (!validator.isEmail(value)) {
                throw new Error('Invalid email')
            }
        }
    },
    password: {
        type: String,
        require: true
    }
}, { versionKey: false, timestamps: true })


userSchema.pre('save', async function() {
    try {
        var user = this;
        const salt = await bcrypt.genSalt(10);
        const hashpassword = await bcrypt.hash(user.password, salt);
        user.password = hashpassword;
    } catch (err) {
        console.log(err)
        throw err;
    }
})

userSchema.methods.comparePassword = async function(userPassword) {
    try {
        const isMatch = await bcrypt.compare(userPassword, this.password);
        return isMatch;
    } catch (err) {
        console.log(err)
        throw err;
    }
}

const UserModel = db.model("user", userSchema);
module.exports = UserModel;