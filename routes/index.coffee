_ = require 'lodash'

exports.index = (req, res) ->
  snackies = []
  for i in [0.._.random 100]
    words = _.shuffle req.app.get('words')
    snackies = snackies.concat words
  res.render 'index',
    title: req.app.get('title'), words: snackies.join ' '
