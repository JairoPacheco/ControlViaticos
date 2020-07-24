const express = require('express');
const cookieParser = require('cookie-parser');
const helmet = require('helmet');

const app = express();

// Routers
const clientsRouter = require('./routes/clients');
const branchOfficesRouter = require('./routes/branchOffices');
const resourcesRouter = require('./routes/resources');
const supportTypesRouter = require('./routes/supportTypes');
const vehiclesRouter = require('./routes/vehicles');
const suppliersRouter = require('./routes/suppliers');

app.use(cookieParser())
app.use(express.urlencoded({ extended: true }));
app.use(express.json());
app.use(helmet());

// Routes
app.use('/clients', clientsRouter);
app.use('/branchOffices', branchOfficesRouter);
app.use('/resources', resourcesRouter);
app.use('/supportTypes', supportTypesRouter);
app.use('/vehicles', vehiclesRouter);
app.use('/suppliers', suppliersRouter);

module.exports = app;