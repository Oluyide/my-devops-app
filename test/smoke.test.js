const test = require('node:test');
const assert = require('node:assert');
const { spawn } = require('node:child_process');
const path = require('node:path');

const SERVER_PATH = path.join(__dirname, '..', 'server.js');

function startServer(port) {
  const proc = spawn('node', [SERVER_PATH], {
    env: { ...process.env, PORT: String(port) },
    stdio: ['ignore', 'pipe', 'pipe'],
  });

  return new Promise((resolve, reject) => {
    const timer = setTimeout(() => {
      proc.kill('SIGKILL');
      reject(new Error('server did not start within 5s'));
    }, 5000);

    proc.stdout.on('data', (chunk) => {
      if (chunk.toString().includes('Listening')) {
        clearTimeout(timer);
        resolve(proc);
      }
    });
    proc.on('error', reject);
  });
}

test('GET /health returns ok', async () => {
  const port = 3457;
  const proc = await startServer(port);
  try {
    const res = await fetch(`http://127.0.0.1:${port}/health`);
    assert.strictEqual(res.status, 200);
    const body = await res.json();
    assert.strictEqual(body.status, 'ok');
    assert.ok(typeof body.uptime === 'number');
  } finally {
    proc.kill('SIGTERM');
  }
});

test('GET / returns greeting', async () => {
  const port = 3458;
  const proc = await startServer(port);
  try {
    const res = await fetch(`http://127.0.0.1:${port}/`);
    assert.strictEqual(res.status, 200);
    const body = await res.json();
    assert.match(body.message, /Hello from my-devops-app/);
    assert.ok(body.hostname);
    assert.ok(body.timestamp);
  } finally {
    proc.kill('SIGTERM');
  }
});
