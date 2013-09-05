express = require 'express'
http = require 'http'
path = require 'path'
routes = require './routes'
metadata = require './package.json'
stylus = require 'stylus'
nib = require 'nib'

fs = require 'fs'
Q = require 'q'
_ = require 'lodash'

app = express()
stems = 'res/stems.txt'
suffixes = 'res/suffixes.txt'
assets = path.join __dirname, 'public'

# All environments
app.set 'port', process.env.PORT or 3000
app.set 'views', __dirname + '/views'
app.set 'view engine', 'jade'
app.set 'title', metadata.name
app.set 'description', metadata.description
app.set 'author', metadata.author
app.set 'version', metadata.version
app.use express.favicon()
app.use express.logger 'dev'
app.use express.bodyParser()
app.use express.methodOverride()
app.use app.router

app.use require('stylus').middleware
  src: assets
  dest: assets
  compile: (str, path) ->
    stylus(str)
      .set('filename', path)
      .set('compress', true)
      .use nib()

app.use express.static assets

# Development environment
app.use express.errorHandler() if app.get('env') is 'development'

# Routes
app.get '/', routes.index

split = (str) ->
  str = str.split '\n'
  _.reject str, (_str) -> _.isEmpty _str

# Main
Q.nfcall(fs.readFile, stems, 'utf-8')
  .then (stems) ->
    app.set 'stems', split stems
  .then ->
    Q.nfcall(fs.readFile, suffixes, 'utf-8')
  .then (suffixes) ->
    app.set 'suffixes', split suffixes
  .then ->
    http.createServer(app).listen app.get('port'), ->
      console.log 'Express server listening on port ' + app.get('port')
  .fail (error) ->
    console.error error
