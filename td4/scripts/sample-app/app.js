//app.js
const express = require('express');
const app = express();
const port = 8080;

app.get('/', (req, res) => {
  res.send('Hello, World!');
});

app.get('/name/:name', (req, res) => {
  const dynamicName = req.params.name;
  res.send(`Hello, ${dynamicName}!`);
});

app.get('/add/:a/:b', (req, res) => {
  const a = parseFloat(req.params.a);
  const b = parseFloat(req.params.b);

  if (isNaN(a) || isNaN(b)) {
    return res.status(400).send("Error: the two parameters must be valid numbers.");
  }

  const sum = a + b;
  res.send({ sum: sum.toString() });
});

// Substraction (TDD - GREEN)
app.get('/subtract/:a/:b', (req, res) => {
  const a = parseFloat(req.params.a);
  const b = parseFloat(req.params.b);

  if (isNaN(a) || isNaN(b)) {
    return res.status(400).send("Error: parameters must be numbers.");
  }

  const result = a - b;
  res.send({ result: result });
});

if (require.main === module) {
  app.listen(port, () => {
    console.log(`Listening on port ${port}`);
  });
}

module.exports = app;