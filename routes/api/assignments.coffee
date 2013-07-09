models = models || require "../../models"

renderJSON = (res)->
    (err, objects)->
        if(err)
            res.json err
        else
            res.json objects

module.exports = assignments = {}


models.ready ->
    assignments =
        Assignment: models.Assignment

        get: (req, res)->
            findObject = {}
            if req.params.id?
                return @Assignment.findOne({id:req.params.id}).exec renderJSON(res)
            if req.query?
                findObject = req.query
            @Assignment.find(findObject).sort("id").exec renderJSON(res)
    
        create: (req, res)->
            @Assignment.create req.body, renderJSON(res)
    
        edit:  (req, res)->
            if req.params.id?
                return @Assignment.findOneAndUpdate({id:req.params.id}, req.body.updateObject).exec renderJSON(res)
            @Assignment.findOneAndUpdate req.body.findObject, req.body.updateObject, renderJSON(res)
    
        destroy: (req, res)->
            if req.params.id?
                return @Assignment.remove {id: req.params.id}, renderJSON(res)
            @Assignment.remove req.body, renderJSON(res)
            
        count: (req, res)->
            Assignment.count renderJSON(res)