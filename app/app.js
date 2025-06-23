const http = require('http');
const port = 3000;

const server = http.createServer((req, res) => {
  res.writeHead(200);
  res.end('✅ hello sj park');
});

server.listen(port, () => {
  console.log(`Server running at http://localhost:${port}/`);
});
