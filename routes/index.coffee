_ = require 'lodash'

exports.index = (req, res) ->
  snackies = []
  for i in [0.._.random 100]
    snackies = snackies.concat _.shuffle req.app.get('words')
  res.render 'index',
    title: req.app.get('title'), words: snackies.join ' '
