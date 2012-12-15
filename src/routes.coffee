{
  user
  postSchedule
  content
  org
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
      user.findOne({}).populate(['postSchedules','contents','sources']).exec (err,item)->
        res.locals.user = item
        next err








    app.get '/',(req,res,next)->
      res.render 'index'








    app.all '/org/:id/:method?',(req,res,next)->
      if req.param.id=='new'
        res.locals.org = new org()
        next()
      else
        org.findById  req.param.id,(err,item)->
          res.locals.org = item 
          next err

    app.get '/org/:id/',(req,res,next)->
      res.render 'org'

    app.post '/org/:id/save',(req,res,next)->
      res.locals.org[k]= v for k,v of req.params.org
      res.locals.org.save next

    app.post '/org/:id/remove',(req,res,next)->
      res.locals.org.remove next

    app.post '/org/:id/:method',(req,res,next)->
      res.redirect 'back'











    app.all '/postSchedule/:id/:method?',(req,res,next)->
      if req.param.id=='new'
        res.locals.postSchedule = new postSchedule()
        next()
      else
        postSchedule.findById req.params.id,(err,item)->
          res.locals.postSchedule = item
          next err

    app.get '/postSchedule/:id/',(req,res,next)->
        res.render 'postSchedule'


    app.post '/postSchedule/:id/save',(req,res,next)->
      res.locals.postSchedule[k]= v for k,v of req.params.postSchedule
      res.locals.postSchedule.save next

    app.post '/postSchedule/:id/remove',(req,res,next)->
      res.locals.postSchedule.remove next

    app.post '/postSchedule/:id/:method',(req,res,next)->
      res.redirect 'back'








    app.all '/content/:id/:method?',(req,res,next)->
      if req.param.id=='new'
        res.locals.content = new content()
        next()
      else
        content.findById req.params.id,(err,item)->
          res.locals.content = item
          next err

    app.get '/content/:id/',(req,res,next)->
      res.render 'content'

    app.post '/content/:id/save',(req,res,next)->
      res.locals.content[k]= v for k,v of req.params.content
      res.locals.content.save next

    app.post '/content/:id/remove',(req,res,next)->
      res.locals.content.remove next

    app.post '/content/:id/:method',(req,res,next)->
      res.redirect 'back'
      