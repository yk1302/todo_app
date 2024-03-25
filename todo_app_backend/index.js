const app = require('./app')
const port = 3000;
const db = require('./configuration/db')
const userModel = require('./model/user.model')
const TodoModel = require('./model/todo.model')

app.get('/', (req, res) => {
    res.send("Hello world from yash")
})


app.listen(port, () => {
    console.log(`Server listening on port:${port}`)
})