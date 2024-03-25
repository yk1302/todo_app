const TodoModel = require('../model/todo.model');

class TodoServices {
    static async createTodo(userId, title, description) {
        const tododata = new TodoModel({ userId, title, description })
        return await tododata.save();
    }

    static async getTodoData(userId) {
        const data = await TodoModel.find({ userId });
        return data;
    }


    static async deleteTodoData(todoId) {
        console.log("Finally deleting data with id", todoId);
        const deletedData = await TodoModel.findByIdAndDelete(todoId);
        console.log(deletedData)
        return deletedData;
    }


}

module.exports = TodoServices