const express = require('express');
const os = require('os');

const app = express();
const PORT = parseInt(process.env.PORT, 10) || 3000;

// testing pull Request
app.get('/', (req, res) => {
  res.json({
    message: 'Hello from my-devops-app - changes made 101',  
    hostname: os.hostname(),
    timestamp: new Date().toISOString(),
  });
});

app.get('/health', (req, res) => {
  res.json({ status: 'ok', uptime: process.uptime() });
});

const server = app.listen(PORT, '0.0.0.0', () => {
  console.log(`Listening on http://0.0.0.0:${PORT}`);
});

const shutdown = (signal) => {
  console.log(`Received ${signal}, shutting down`);
  server.close(() => process.exit(0));
};
process.on('SIGTERM', () => shutdown('SIGTERM'));
process.on('SIGINT', () => shutdown('SIGINT'));
