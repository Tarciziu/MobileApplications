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


const players = [{
  pid: 1,
  name: "Gheorghe Hagi",
  team: "Galatasaray",
  market_value: 10000000,
  position: "LW",
  age: 56
  },
  {
  pid: 2,
  name: "Lionel Messi",
  team: "PSG",
  market_value: 100000000,
  position: "RW",
  age: 34
  },
  {
    pid: 3,
    name: "Cristiano Ronaldo",
    team: "Manchester United",
    market_value: 90000000,
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
        return obj.pid;
      })) + 1;
      let obj = {
        pid: maxId,
        name: name,
        team: team,
        market_value: marketValue,
        position: position,
        age: age,
      };
      // console.log("created: " + JSON.stringify(license));
      players.push(obj);
      let data = {
        player: obj,
        operation: "add"
      }
      broadcast(data);
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
router.del('/player/:pid', ctx => {
  // console.log("ctx: " + JSON.stringify(ctx));
  const headers = ctx.params;
  // console.log("body: " + JSON.stringify(headers));
  const id = headers.pid;
  if (typeof id !== 'undefined') {
    const index = players.findIndex(obj => obj.pid == id);
    if (index === -1) {
      console.log("No player with id: " + id);
      ctx.response.body = {text: 'Invalid player id'};
      ctx.response.status = 404;
    } else {
      let obj = players[index];
      // console.log("deleting: " + JSON.stringify(obj));
      players.splice(index, 1);
      ctx.response.body = obj;
      let data = {
        player: id,
        operation: "del"
      }
      broadcast(data)
      ctx.response.status = 200;
    }
  } else {
    console.log("Missing or invalid fields!");
    ctx.response.body = {text: 'Id missing or invalid'};
    ctx.response.status = 404;
  }
});

// TODO: update with broadcast
router.patch('/player/update', ctx => {
  console.log("ctx: " + JSON.stringify(ctx.request.body));
  const headers = ctx.request.body;
  const id = headers.pid;
  const name = headers.name;
  const team = headers.team;
  const marketValue = headers.market_value;
  const position = headers.position;
  const age = headers.age;

  if (typeof name !== 'undefined' && typeof team !== 'undefined' && typeof marketValue !== 'undefined'
    && position !== 'undefined' && age !== 'undefined') {
      const index = players.findIndex(obj => obj.pid == id);
      if (index === -1) {
        console.log("Player doesn't exists!");
        ctx.response.body = {text: "Player doesn't exists!"};
        ctx.response.status = 404;
      } else {
        let obj = {
          pid: id,
          name:name,
          team:team,
          market_value:marketValue,
          position:position,
          age: age
        };
        players[index] = obj;
        let data = {
          player: obj,
          operation: "update"
        }
        broadcast(data);
        ctx.response.body = obj;
        ctx.response.status = 200;
      }
  } else {
    console.log("Missing or invalid fields!");
    ctx.response.body = {text: 'Missing or invalid fields!'};
    ctx.response.status = 404;
  }
});

app.use(router.routes());
app.use(router.allowedMethods());

server.listen(2022);
