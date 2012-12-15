{
  user
  postSchedule
  content
  source
  connectDb
}                              = require './models'
connectDb (err)->
  if err
    console.error err 
    process.exit 1

module.exports                 = class Routes
  constructor                  : (app)->
    @mount app if app?
  mount                        : (app)->
    app.get '*',(req,res,next)->
      user.find({}).populate(['postSchedules','contents','sources']).exec (err,item)->
        res.locals.user = item[0]
        next err

    app.get '/',(req,res,next)->
      res.render 'index'

    app.get '/org/:id/'


    app.get '/postSchedule/:id/',(req,res,next)->
      postSchedule.findById req.params.id,(err,item)->
        res.locals.postSchedule = item
        next err

    app.get '/postSchedule/:id/',(req,res,next)->
        res.render 'postSchedule'

    app.get '/content/:id/',(req,res,next)->
      content.findByID req.params.id,(err,item)->
        res.locals.content = item
        next err

    app.get '/content/:id/',(req,res,next)->
      res.render 'content'
      