const express = require('express');
const cookieParser = require('cookie-parser');
const helmet = require('helmet');

const app = express();

// Routers
const branchOfficesRouter = require('./routes/branchOffices');
const clientsRouter = require('./routes/clients');
const reasonRouter = require('./routes/reason');
const viaticumTypeRouter = require('./routes/viaticumType');
const taskTypeRouter = require('./routes/taskType');
const resourceRouter = require('./routes/resource');
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
app.use('/reason', reasonRouter);
app.use('/viaticumType', viaticumTypeRouter);
app.use('/taskType', taskTypeRouter);
app.use('/resource', resourceRouter);
app.use('/costs', costsRouter);
app.use('/tasks', tasksRouter);
app.use('/supportTypes', supportTypesRouter);
app.use('/vehicles', vehiclesRouter);
app.use('/suppliers', suppliersRouter);


module.exports = app;