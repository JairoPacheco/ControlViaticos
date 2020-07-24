const express = require('express');
const cookieParser = require('cookie-parser');
const helmet = require('helmet');

const app = express();

// Routers
const branchOfficesRouter = require('./routes/branchOffices');
const clientsRouter = require('./routes/clients');
const costsRouter = require('./routes/costs');
const laborsRouter = require('./routes/labors');
const resourcesRouter = require('./routes/resources');
const supportTypesRouter = require('./routes/supportTypes');
const vehiclesRouter = require('./routes/vehicles');

app.use(cookieParser())
app.use(express.urlencoded({ extended: true }));
app.use(express.json());
app.use(helmet());

// Routes
app.use('/branchOffices', branchOfficesRouter);
app.use('/clients', clientsRouter);
app.use('/costs', costsRouter);
app.use('/labors', laborsRouter);
app.use('/resources', resourcesRouter);
app.use('/supportTypes', supportTypesRouter);
app.use('/vehicles', vehiclesRouter);

module.exports = app;