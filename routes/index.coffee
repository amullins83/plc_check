# GET home page.

exports.index = (req, res)->
  res.render 'index'

exports.partial = (req, res)->
  name = req.params.name
  res.render "partials/partial#{name}"