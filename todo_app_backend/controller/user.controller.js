const UserService = require('../services/user.services');

exports.register = async(req, res, next) => {
    try {
        const { email, password } = req.body;

        const createUser = await UserService.registerUser(email, password);
        res.json({
            status: true,
            message: "User has created...",
            data: createUser
        });
    } catch (err) {
        res.json({
            status: false,
            message: "Error in creating user.....",
            error: err.toString()
        })
    }
}

exports.login = async(req, res, next) => {
    try {
        const { email, password } = req.body;

        const user = await UserService.checkUser(email);
        if (!user) {
            res.status(404).json({
                status: false,
                message: "Such User doesn't exist"
            })
            throw new Error('User not exist...');
        }
        // compare the given password with the hashed one  
        let isMatch = await user.comparePassword(password);
        if (isMatch === false) {
            res.status(404).json({
                status: false,
                message: "Invalid Password"
            })
            throw new Error("Password invalid");
        }

        let tokenData = { _id: user._id, email: user.email };

        const token = await UserService.generateToken(tokenData, 'secretKey007', '1h');
        //we are sending this token to the client side for further use                    

        res.status(200).json({
            status: true,
            message: "User has LogIn correctly...",
            token: token
        });
    } catch (err) {
        res.json({
            status: false,
            message: "Error in creating user.....",
            error: err.toString()
        })
    }
}