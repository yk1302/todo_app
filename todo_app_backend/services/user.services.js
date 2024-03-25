const UserModel = require('../model/user.model')
const jwt = require('jsonwebtoken')
class USerService {
    static async registerUser(email, password) {
        try {
            const user = new UserModel({ email, password });
            console.log(user);
            return await user.save();
        } catch (err) {
            console.log(err)
            throw err
        }


    }

    static async checkUser(email) {
        try {
            return await UserModel.findOne({ email: email })
        } catch (err) {
            console.log(err)
            throw err
        }
    }

    static async generateToken(data, secretKey, jwt_expire) {
        return jwt.sign(data, secretKey || 'mySecret', { expiresIn: jwt_expire })

    }
}

module.exports = USerService;