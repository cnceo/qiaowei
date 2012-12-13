{
  User
  Schedule
}                              = require './models'
module.exports                 = class Routes
  constructor                  : (app)->
    @mount app if app?
  mount                        : (app)->
    app.get '*',(req,res,next)->
      Schedule.find {},(err,items)-> 
        res.locals.allSchedule = items
        next err

    app.get '/',(req,res,next)->
      res.render 'index'