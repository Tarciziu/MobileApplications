var koa = require('koa');
var app = module.exports = new koa();
const server = require('http').createServer(app.callback());
const WebSocket = require('ws');
const wss = new WebSocket.Server({server});
const Router = require('koa-router');
const cors = require('@koa/cors');
const bodyParser = require('koa-bodyparser');

app.use(bodyParser());

app.use(cors());

app.use(middleware);

function middleware(ctx, next) {
  const start = new Date();
  return next().then(() => {
    const ms = new Date() - start;
    console.log(`${start.toLocaleTimeString()} ${ctx.request.method} ${ctx.request.url} ${ctx.response.status} - ${ms}ms`);
  });
}

const vehicles = [];

const players = [{
  id: 1,
  name: "Gheorghe Hagi",
  team: "Galatasaray",
  marketValue: 10000000,
  position: "LW",
  age: 56
  },
  {
  id: 2,
  name: "Lionel Messi",
  team: "PSG",
  marketValue: 100000000,
  position: "RW",
  age: 34
  },
  {
    id: 3,
    name: "Cristiano Ronaldo",
    team: "Manchester United",
    marketValue: 90000000,
    position: "ST",
    age: 36
    },
];


const router = new Router();

// get all
// router.get('/all', ctx => {
//   ctx.response.body = vehicles;
//   ctx.response.status = 200;
// });

router.get('/all', ctx => {
  ctx.response.body = players;
  ctx.response.status = 200;
});



const broadcast = (data) =>
  wss.clients.forEach((client) => {
    if (client.readyState === WebSocket.OPEN) {
      client.send(JSON.stringify(data));
    }
  });

// create 
router.post('/player', ctx => {
  // console.log("ctx: " + JSON.stringify(ctx));
  const headers = ctx.request.body;
  // console.log("body: " + JSON.stringify(headers));
  const name = headers.name;
  const team = headers.team;
  const marketValue = headers.marketValue;
  const position = headers.position;
  const age = headers.age;
  if (typeof name !== 'undefined' && typeof team !== 'undefined' && typeof marketValue !== 'undefined'
    && position !== 'undefined' && age !== 'undefined') {
    const index = players.findIndex(obj => obj.name == name);
    if (index !== -1) {
      console.log("Player already exists!");
      ctx.response.body = {text: 'Player already exists!'};
      ctx.response.status = 404;
    } else {
      let maxId = Math.max.apply(Math, players.map(function (obj) {
        return obj.id;
      })) + 1;
      let obj = {
        id: maxId,
        name,
        status: 'new',
        team,
        marketValue,
        position,
        age
      };
      // console.log("created: " + JSON.stringify(license));
      players.push(obj);
      broadcast(obj);
      ctx.response.body = obj;
      ctx.response.status = 200;
    }
  } else {
    console.log("Missing or invalid fields!");
    ctx.response.body = {text: 'Missing or invalid fields!'};
    ctx.response.status = 404;
  }
});

// delete one by id
// TODO: add broadcast for deleting
router.del('/vehicle/:id', ctx => {
  // console.log("ctx: " + JSON.stringify(ctx));
  const headers = ctx.params;
  // console.log("body: " + JSON.stringify(headers));
  const id = headers.id;
  if (typeof id !== 'undefined') {
    const index = vehicles.findIndex(obj => obj.id == id);
    if (index === -1) {
      console.log("No vehicle with id: " + id);
      ctx.response.body = {text: 'Invalid vehicle id'};
      ctx.response.status = 404;
    } else {
      let obj = vehicles[index];
      // console.log("deleting: " + JSON.stringify(obj));
      vehicles.splice(index, 1);
      ctx.response.body = obj;
      ctx.response.status = 200;
    }
  } else {
    console.log("Missing or invalid fields!");
    ctx.response.body = {text: 'Id missing or invalid'};
    ctx.response.status = 404;
  }
});

// TODO: update with broadcast

app.use(router.routes());
app.use(router.allowedMethods());

server.listen(2021);
