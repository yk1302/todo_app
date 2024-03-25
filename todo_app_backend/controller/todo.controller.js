const TodoService = require('../services/todo.services');

exports.createTodo = async(req, res, next) => {
    try {
        const { userId, title, description } = req.body;
        const todo = await TodoService.createTodo(userId, title, description);

        res.status(201).json({ status: true, message: "Add Todo data successfully", data: { todo } });
    } catch (err) {
        console.log(err)
        return next(new Error.BadRequestError)
    }
}

exports.getUserTodoData = async(req, res, next) => {
    try {
        const { userId } = req.body;
        console.log("fetch request has come..............")
        const todo = await TodoService.getTodoData(userId);
        console.log(todo)
        res.status(201).json({ status: true, message: "Todo Data fetch succesfully as below:", data: todo });
    } catch (err) {
        console.log(err)
        return next(new Error.BadRequestError)
    }
}

exports.deleteUSerTodoData = async(req, res, next) => {
    try {
        const { ItemId } = req.body;
        console.log("delete data", ItemId)
        const deletedTodo = await TodoService.deleteTodoData(ItemId);
        console.log(deletedTodo)
        res.status(201).json({ status: true, message: "Todo Data has been deleted:", data: deletedTodo });
    } catch (err) {
        console.log(err)
        return next(new Error.BadRequestError)
    }
}