const router = require('express').Router();
const TodoController = require('../controller/todo.controller')

router.post('/AddTodo', TodoController.createTodo);
router.post("/GetUserTodoData", TodoController.getUserTodoData);
router.post("/DeleteTodoData", TodoController.deleteUSerTodoData);

module.exports = router;