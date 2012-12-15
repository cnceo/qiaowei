{
  user
  postSchedule
  content
  org
  member
  connectDb
}                              = require './models'
fs = require 'fs'
path = require 'path'
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
_ = require 'underscore'
module.exports                 = class Routes
  constructor                  : (app)->
    @mount app if app?
  mount                        : (app)->

    app.all '*',(req,res,next)->
      return next() unless req.session.username
      user.findOne({name:req.session.username})
      .populate('owns')
      .exec (err,item)->
        res.locals.user = item
        next err

    app.get '/logout',(req,res,next)->
      req.session.username= null
      res.redirect '/login'

    app.get '/login',(req,res,next)->
      res.locals.authorize = {
        "login" : authorize.sina(config.sdks.sina)
      }
      res.render 'login'



    
    app.get '/sina_auth_cb', (req, res, next) ->
      sina.oauth.accesstoken req.query.code , (error, data)->
        access_token = data.access_token 
        sina.users.show {source:config.sdks.sina.app_key,uid:data.uid,access_token:access_token,method:"GET"}, (error, data)->
          name = data.screen_name
          user.findOne {name:name},(err,item)->
          item = new user() unless item?
          item.name= name
          item.sinaToken= access_token
          item.save (err)->
            req.session.username = name
            res.redirect("/")


    app.all '*',(req,res,next)->
      if res.locals.user
        member.find({name:res.locals.user.name})
        .populate('org')
        .exec (err,items)->
          res.locals.userOrg= res.locals.user.owns[0]
          if items.length
            res.locals.userOrg||=items[0].org
          next()
      else
        res.redirect '/login'

 
    app.get '/tqq_auth_cb', (req, res, next) ->
      res.locals.user.qqToken.pop()
      res.locals.user.qqToken.pop()
      return next() unless req.query.code
      tqq.oauth.accesstoken req.query.code , (error, data)->
        access_token = data.access_token
        openid = data.openid
        tqq.user.info {clientip:"115.193.182.232",openid:openid,access_token:access_token},(error,data)->
          res.locals.user.qqName = data.data.nick
          res.locals.user.qqToken.push access_token
          res.locals.user.qqToken.push openid
          next()

    app.get '/tqq_auth_cb', (req, res, next) ->    
      res.locals.user.save next
    app.get '/tqq_auth_cb', (req, res, next) ->
      res.redirect("/")


    app.get '/renren_auth_cb', (req, res, next) ->
      res.locals.user.renrenToken= null
      return next() unless req.query.code
      renren.oauth.accesstoken req.query.code , (error, data)->
        access_token = data.access_token
        res.locals.user.renrenToken= access_token
        renren.users.getInfo {access_token:access_token},(error,data)->
          res.locals.user.renrenName = data[0].name
          next()

    app.get '/renren_auth_cb', (req, res, next) ->    
      res.locals.user.save next
    app.get '/renren_auth_cb', (req, res, next) ->
      res.redirect("/")



       
    app.get '/douban_auth_cb', (req, res, next) ->
      res.locals.user.doubanToken= null
      return next() unless req.query.code
      douban.oauth.accesstoken req.query.code , (error, data)->
        access_token = data.access_token
        res.locals.user.doubanToken= access_token
        douban.user.me {access_token:access_token}, (error,data)->
          res.locals.user.doubanName= data.name
          console.log res.locals.user
          next()

    app.get '/douban_auth_cb', (req, res, next) ->    
      res.locals.user.save next
    app.get '/douban_auth_cb', (req, res, next) ->
      res.redirect("/")


    app.get '/',(req,res,next)->
      res.locals.authorize = 
        "logout" : authorize.sina(_.extend({forcelogin:true},config.sdks.sina))
        "sina" : authorize.sina(config.sdks.sina)
        "renren" : authorize.renren(config.sdks.renren)
        "douban" : authorize.douban(config.sdks.douban)
        "tqq" : authorize.tqq(config.sdks.tqq)
      res.render 'i'



    app.all '/org/new/',(req,res,next)->
      res.locals.org = new org
        owner: res.locals.user
      res.locals.user.owns.push res.locals.org
      res.locals.user.save next
    app.all '/org/new/',(req,res,next)->
      res.locals.org.save next
    app.all '/org/new/',(req,res,next)->
      res.redirect "/org/#{res.locals.org._id}/"

    app.all '/org/:id/*',(req,res,next)->
      org.findById(req.params.id)
      .populate('owner')
      .populate('postSchedules')
      .populate('members')
      .populate('contents').exec (err,item)->
        res.locals.org = item 
        next err

    app.all '/org/:id/*',(req,res,next)->
      return res.send 404 unless res.locals.org
      next()
    app.get '/org/:id/',(req,res,next)->
      res.render 'org'
        mode: req.query.mode

    app.post '/org/:id/save',(req,res,next)->
      res.locals.org[k]= v for k,v of req.body.org
      res.locals.org.save next

    app.post '/org/:id/remove',(req,res,next)->
      res.locals.org.remove next


    app.all '/org/:id/setHead',(req,res,next)->
      headPath= path.join(__dirname,'..','assets',"org#{res.locals.org._id}head.jpg")
      if req.files.file&&req.files.file.name
        stream= fs.createReadStream req.files.file.path
        stream.pipe fs.createWriteStream headPath 
        stream.on 'close',next
      else
        fs.unlink headPath,(err)->
          next()
    app.all '/org/:id/setFoot',(req,res,next)->
      headPath= path.join(__dirname,'..','assets',"org#{res.locals.org._id}foot.jpg")
      if req.files.file&&req.files.file.name
        stream= fs.createReadStream req.files.file.path
        stream.pipe fs.createWriteStream headPath 
        stream.on 'close',next
      else
        fs.unlink headPath,(err)->
          next()

    app.all '/org/:id/:method',(req,res,next)->
      res.redirect 'back'




    app.post '/org/:id/members/new',(req,res,next)->
      newMember= new member
        name:req.body.member.name
        org:res.locals.org
      res.locals.org.members.push newMember
      newMember.save next


    app.post '/org/:id/members/new',(req,res,next)->
      res.locals.org.save next

    app.post '/org/:id/members/new',(req,res,next)->
      res.redirect 'back'

    app.all '/org/:id/members/:name/remove',(req,res,next)->
      member.remove {name:req.params.name},next

    app.all '/org/:id/members/:name/:method',(req,res,next)->
      res.redirect 'back'



    app.all '/org/:id/postSchedules/new',(req,res,next)->
      res.locals.postSchedule = new postSchedule
        org: res.locals.org
      res.locals.org.postSchedules.push res.locals.postSchedule
      res.locals.postSchedule.save next
    app.all '/org/:id/postSchedules/new',(req,res,next)->
      res.locals.org.save next
    app.all '/org/:id/postSchedules/new',(req,res,next)->
      res.redirect "/postSchedule/#{res.locals.postSchedule._id}/"


    app.all '/postSchedule/:id/*',(req,res,next)->
      postSchedule.findById req.params.id,(err,item)->
        res.locals.postSchedule = item
        next err

    app.all '/postSchedule/:id/*',(req,res,next)->
      org.findById(res.locals.postSchedule.org).populate('contents').exec (err,item)->
        res.locals.org= item
        next err

    app.all '/postSchedule/:id/*',(req,res,next)->
      return res.send 404 unless res.locals.postSchedule
      next()
    app.get '/postSchedule/:id/',(req,res,next)->
      res.render 'postSchedule'


    app.all '/postSchedule/:id/save',(req,res,next)->
      res.locals.postSchedule[k]= v for k,v of req.body.postSchedule
      res.locals.postSchedule.save next

    app.all '/postSchedule/:id/remove',(req,res,next)->
      res.locals.postSchedule.remove next

    app.all '/postSchedule/:id/:method',(req,res,next)->
      res.redirect "/org/#{res.locals.postSchedule.org._id}/?mode=postSchedules"






    app.post '/org/:id/contents/new',(req,res,next)->
      res.locals.content = new content
        org: res.locals.org
        creator: res.locals.user.name
      res.locals.content[k]= v for k,v of req.body.content
      res.locals.org.contents.push res.locals.content
      res.locals.content.save next
    app.post '/org/:id/contents/new',(req,res,next)->
      res.locals.org.save next
    app.post '/org/:id/contents/new',(req,res,next)->
      res.redirect "/org/#{res.locals.org._id}/"


    app.all '/content/:id/*',(req,res,next)->
      content.findById(req.params.id).populate('org').exec (err,item)->
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

    app.all '/content/:id/remove',(req,res,next)->
      res.locals.content.remove next

    app.all '/content/:id/:method',(req,res,next)->
      res.redirect 'back'
    
