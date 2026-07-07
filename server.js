const express = require('express');
const app = express();
const PORT = 3000;

// Set by the blue/green Deployment manifests; defaults keep local runs working
const VERSION = process.env.APP_VERSION || 'v1';
const COLOR = process.env.APP_COLOR || 'blue';

app.get('/', (req, res) => {
  res.send(`
    <body style="background:${COLOR};color:white;font-family:sans-serif;
                 display:flex;align-items:center;justify-content:center;height:95vh;margin:0">
      <div style="text-align:center">
        <h1>Hello from DevOps Cloud Project!</h1>
        <h2>${COLOR.toUpperCase()} environment &mdash; ${VERSION}</h2>
      </div>
    </body>
  `);
});

app.get('/health', (req, res) => {
  res.json({ status: 'ok', version: VERSION, color: COLOR });
});

app.listen(PORT, () => {
  console.log(`Server running on port ${PORT} (${COLOR} ${VERSION})`);
});
