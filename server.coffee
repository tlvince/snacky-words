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
words = 'res/words.txt'
assets = path.join __dirname, 'public'

# All environments
app.set 'port', process.env.PORT or 3000
app.set 'views', __dirname + '/views'
app.set 'view engine', 'jade'
app.set 'title', metadata.name + ' v' + metadata.version
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

# Main
Q.nfcall(fs.readFile, words, 'utf-8')
  .then (words) ->
    words = words.split '\n'
    words = _.reject words, (word) -> _.isEmpty word
    app.set 'words', words
  .then ->
    http.createServer(app).listen app.get('port'), ->
      console.log 'Express server listening on port ' + app.get('port')
  .fail (error) ->
    console.error error
