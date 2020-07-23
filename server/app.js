const express = require('express');
const cookieParser = require('cookie-parser');
const helmet = require('helmet');

const app = express();

// Routers
const clientsRouter = require('./routes/clients');
const reasonRouter = require('./routes/reason');
const viaticumTypeRouter = require('./routes/viaticumType');
const taskTypeRouter = require('./routes/taskType');
const resourceRouter = require('./routes/resource');

app.use(cookieParser())
app.use(express.urlencoded({ extended: true }));
app.use(express.json());
app.use(helmet());

// Routes
app.use('/clients', clientsRouter);
app.use('/reason', reasonRouter);
app.use('/viaticumType', viaticumTypeRouter);
app.use('/taskType', taskTypeRouter);
app.use('/resource', resourceRouter);

module.exports = app;