const express = require('express');
const cookieParser = require('cookie-parser');
const helmet = require('helmet');

const app = express();

// Routers
const clientsRouter = require('./routes/clients');

app.use(cookieParser())
app.use(express.urlencoded({ extended: true }));
app.use(express.json());
app.use(helmet());

// Routes
app.use('/clients', clientsRouter);

module.exports = app;