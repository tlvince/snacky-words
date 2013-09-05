_ = require 'lodash'

exports.index = (req, res) ->
  snackys = []

  for i in [0.._.random 100]
    stems = _.shuffle req.app.get('stems')

    words = _.map stems, (stem) ->
      if Math.random() < 0.5
        suffixes = _.shuffle req.app.get('suffixes')
        return stem + suffixes[0]
      stem

    snackys = snackys.concat words

  res.render 'index',
    title: req.app.get('title')
    author: req.app.get('author')
    description: req.app.get('description')
    version: req.app.get('version')
    words: snackys.join ' '
