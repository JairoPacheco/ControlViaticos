const express = require('express');
const cookieParser = require('cookie-parser');
const helmet = require('helmet');

const app = express();

// Routers
const branchOfficesRouter = require('./routes/branchOffices');
const clientsRouter = require('./routes/clients');
const reasonsRouter = require('./routes/reasons');
const expenseTypesRouter = require('./routes/expenseTypes');
const tasksTypeRouter = require('./routes/taskTypes');
const resourcesRouter = require('./routes/resources');
const costsRouter = require('./routes/costs');
const tasksRouter = require('./routes/tasks');
const supportTypesRouter = require('./routes/supportTypes');
const vehiclesRouter = require('./routes/vehicles');
const suppliersRouter = require('./routes/suppliers');

app.use(cookieParser())
app.use(express.urlencoded({ extended: true }));
app.use(express.json());
app.use(helmet());

// Routes
app.use('/branchOffices', branchOfficesRouter);
app.use('/clients', clientsRouter);
app.use('/reasons', reasonsRouter);
app.use('/expenseTypes', expenseTypesRouter);
app.use('/taskTypes', tasksTypeRouter);
app.use('/resources', resourcesRouter);
app.use('/costs', costsRouter);
app.use('/tasks', tasksRouter);
app.use('/supportTypes', supportTypesRouter);
app.use('/vehicles', vehiclesRouter);
app.use('/suppliers', suppliersRouter);


module.exports = app;