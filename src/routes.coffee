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







    app.all '/org/new/',(req,res,next)->
      res.locals.org = new org()
      res.locals.org.save next
    app.all '/org/new/',(req,res,next)->
      res.redirect "/org/#{res.locals.org._id}/"

    app.all '/org/:id/:method?',(req,res,next)->
      org.findById(req.params.id).populate(['postSchedule','user','content']).exec (err,item)->
        res.locals.org = item 
        next err

    app.get '/org/:id/',(req,res,next)->
      res.render 'org'

    app.post '/org/:id/save',(req,res,next)->
      res.locals.org[k]= v for k,v of req.body.org
      res.locals.org.save next

    app.post '/org/:id/remove',(req,res,next)->
      res.locals.org.remove next

    app.post '/org/:id/:method',(req,res,next)->
      res.redirect 'back'








    app.all '/postSchedule/new/',(req,res,next)->
      res.locals.postSchedule = new postSchedule()
      res.locals.postSchedule.save next
    app.all '/postSchedule/new/',(req,res,next)->
      res.redirect "/postSchedule/#{res.locals.postSchedule._id}/"




    app.all '/postSchedule/:id/:method?',(req,res,next)->
      postSchedule.findById req.params.id,(err,item)->
        res.locals.postSchedule = item
        next err

    app.get '/postSchedule/:id/',(req,res,next)->
        res.render 'postSchedule'


    app.post '/postSchedule/:id/save',(req,res,next)->
      res.locals.postSchedule[k]= v for k,v of req.body.postSchedule
      res.locals.postSchedule.save next

    app.post '/postSchedule/:id/remove',(req,res,next)->
      res.locals.postSchedule.remove next

    app.post '/postSchedule/:id/:method',(req,res,next)->
      res.redirect 'back'






    app.all '/content/new/',(req,res,next)->
      res.locals.content = new content()
      res.locals.content.save next
    app.all '/content/new/',(req,res,next)->
      res.redirect "/content/#{res.locals.content._id}/"


    app.all '/content/:id/:method?',(req,res,next)->
      content.findById req.params.id,(err,item)->
        res.locals.content = item
        next err

    app.get '/content/:id/',(req,res,next)->
      res.render 'content'

    app.post '/content/:id/save',(req,res,next)->
      res.locals.content[k]= v for k,v of req.body.content
      res.locals.content.save next

    app.post '/content/:id/remove',(req,res,next)->
      res.locals.content.remove next

    app.post '/content/:id/:method',(req,res,next)->
      res.redirect 'back'
      