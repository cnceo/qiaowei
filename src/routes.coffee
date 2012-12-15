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
config = require './../config.js'
authorize = require './../sdk/authorize.js'
Sina = require './../sdk/sina.js',
TQQ =  require './../sdk/tqq.js',
RenRen = require './../sdk/renren.js',
Douban = require './../sdk/douban.js'
sina = new Sina(config.sdks.sina)
tqq = new TQQ(config.sdks.tqq)
renren = new RenRen(config.sdks.renren)
douban = new Douban(config.sdks.douban)

module.exports                 = class Routes
  constructor                  : (app)->
    @mount app if app?
  mount                        : (app)->
    app.get '/login',(req,res,next)->
      res.render 'login'

      
    app.get '*',(req,res,next)->
      user.findOne({name:'admin'})
      .populate('owns')
      .populate('editorOf')
      .populate('posterOf')
      .exec (err,item)->
        res.locals.user = item
        next err

    app.get '*',(req,res,next)->
      if res.locals.user    
        next()
      else
        res.redirect '/login'


    app.get '/',(req,res,next)->
      res.locals.userOrg= res.locals.user.owns[0]||res.locals.user.editorOf[0]||res.locals.posterOf[0]||null
      res.locals.authorize = {
        "sina" : authorize.sina(config.sdks.sina),
        "renren" : authorize.renren(config.sdks.renren),
        "douban" : authorize.douban(config.sdks.douban),
        "tqq" : authorize.tqq(config.sdks.tqq)
      }
      res.render 'i'







    app.all '/org/new/',(req,res,next)->
      res.locals.org = new org
        owner: res.locals.user
      
      res.locals.org.save next
    app.all '/org/new/',(req,res,next)->
      res.redirect "/org/#{res.locals.org._id}/"

    app.all '/org/:id/*',(req,res,next)->
      org.findById(req.params.id).populate('postSchedules')
      .populate('editors')
      .populate('posters')
      .populate('contents').exec (err,item)->
        res.locals.org = item 
        next err

    app.all '/org/:id/*',(req,res,next)->
      return res.send 404 unless res.locals.org
      next()
    app.get '/org/:id/',(req,res,next)->
      res.render 'org'

    app.post '/org/:id/save',(req,res,next)->
      res.locals.org[k]= v for k,v of req.body.org
      res.locals.org.save next

    app.post '/org/:id/remove',(req,res,next)->
      res.locals.org.remove next

    app.post '/org/:id/:method',(req,res,next)->
      res.redirect 'back'

    app.post '/org/:id/editor/new',(req,res,next)->
      user.findOne {name:req.body.user.name},(err,item)->
        res.locals.newEditor = item
        next err




    app.post '/org/:id/editor/new',(req,res,next)->
      return res.send 404 unless res.locals.newEditor
      next()
    app.post '/org/:id/editor/new',(req,res,next)->
      res.locals.newEditor.editorOf.push res.locals.org
      res.locals.org.editors.push res.locals.newEditor
      res.locals.org.save next

    app.post '/org/:id/editor/new',(req,res,next)->
      res.locals.newEditor.save next

    app.post '/org/:id/editor/new',(req,res,next)->
      res.redirect 'back'




    app.post '/org/:id/poster/new',(req,res,next)->
      user.findOne {name:req.body.user.name},(err,item)->
        res.locals.newPoster = item
        next err

    app.post '/org/:id/poster/new',(req,res,next)->
      return res.send 404 unless res.locals.newPoster
      next()
    app.post '/org/:id/poster/new',(req,res,next)->
      res.locals.newPoster.posterOf.push res.locals.org
      res.locals.org.posters.push res.locals.newPoster
      res.locals.org.save next

    app.post '/org/:id/poster/new',(req,res,next)->
      res.locals.newPoster.save next

    app.post '/org/:id/poster/new',(req,res,next)->
      res.redirect 'back'






    app.all '/postSchedule/new/',(req,res,next)->
      res.locals.postSchedule = new postSchedule()
      res.locals.postSchedule.save next
    app.all '/postSchedule/new/',(req,res,next)->
      res.redirect "/postSchedule/#{res.locals.postSchedule._id}/"


    app.all '/postSchedule/:id/*',(req,res,next)->
      postSchedule.findById req.params.id,(err,item)->
        res.locals.postSchedule = item
        next err

    app.all '/postSchedule/:id/*',(req,res,next)->
      return res.send 404 unless res.locals.postSchedule
      next()
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


    app.all '/content/:id/*',(req,res,next)->
      content.findById req.params.id,(err,item)->
        res.locals.content = item
        next err

    app.all '/content/:id/*',(req,res,next)->
      return res.send 404 unless res.locals.content
      next()
    app.get '/content/:id/',(req,res,next)->
      res.render 'content'

    app.post '/content/:id/save',(req,res,next)->
      res.locals.content[k]= v for k,v of req.body.content
      res.locals.content.save next

    app.post '/content/:id/remove',(req,res,next)->
      res.locals.content.remove next

    app.post '/content/:id/:method',(req,res,next)->
      res.redirect 'back'
    
    
    app.get '/sina_auth_cb', (req, res, next) ->
      sina.oauth.accesstoken req.query.code , (error, data)->
        access_token = data.access_token 
        res.cookie('sina_token',access_token);
        res.redirect("/")          
       
    app.get '/tqq_auth_cb', (req, res, next) ->
      tqq.oauth.accesstoken req.query.code , (error, data)->
        access_token = data.access_token
        openid = data.openid
        res.cookie('tqq_token',access_token);
        res.cookie('tqq_openid',openid);
        res.redirect("/")

    app.get '/renren_auth_cb', (req, res, next) ->
      renren.oauth.accesstoken req.query.code , (error, data)->
        access_token = data.access_token
        openid = data.openid
        res.cookie('renren_token',access_token);
        res.redirect("/")
       
    app.get '/douban_auth_cb', (req, res, next) ->
      douban.oauth.accesstoken req.query.code , (error, data)->
        access_token = data.access_token
        openid = data.openid
        res.cookie('douban_token',access_token);
        res.redirect("/")