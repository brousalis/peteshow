express = require('express')
app = express()
app.use(express.static(__dirname + '/../.generated/'))
app.set('view engine', 'ejs')
app.set('views', __dirname)

defaults =
  host: 'http://localhost'
  port: 3002

port = defaults.port
host = defaults.host

env = process.env.NODE_ENV

app.get '/', (req, res) -> res.render('index', {env: env})
app.listen(port)

if (env != 'test')
  console.log("[TEST_SERVER] Server running at: #{host}:#{port}")
