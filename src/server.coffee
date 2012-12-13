
###
Module dependencies.
###
express        = require("express")
routes         = require("./routes")
http           = require("http")
path           = require("path")
module.exports = app = express()
app.configure ->
  app.set "port", process.env.PORT or 3000
  app.set "views", path.join __dirname , '..' , 'views'
  app.set "view engine", "jade"
  app.use express.favicon()
  app.use express.logger("dev")
  app.use express.bodyParser()
  app.use express.methodOverride()
  app.use app.router
  app.use express.static path.join __dirname, "public"

app.configure "development", ->
  app.use express.errorHandler()

routing        = new routes(app)