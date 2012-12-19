{
  user
  postSchedule
  content
  org
  member
  connectDb
}                              = require './models'
im = require 'imagemagick'
config = require './../config.js'
Sina = require './../sdk/sina.js',
TQQ =  require './../sdk/tqq.js',
RenRen = require './../sdk/renren.js',
Douban = require './../sdk/douban.js'
sina = new Sina(config.sdks.sina)
tqq = new TQQ(config.sdks.tqq)
renren = new RenRen(config.sdks.renren)
douban = new Douban(config.sdks.douban)
path = require 'path'
fs = require 'fs'
moment = require 'moment'
postQueue = []
sendSNS= (content,pic,type,token,cb)->
  if type=="sina"
    if pic
      sina.statuses.upload {status:content,pic:pic,access_token:token},(error,data)->
        console.log(error)
        cb()
    else
      sina.statuses.update {status:content,access_token:token},(error,data)->
        console.log(error)
        cb()
  if type=="qq"
    if pic
      tqq.t.add_pic {
        content:content,
        clientip:"115.193.182.232",
        pic:pic,
        openid:token[1],
        access_token:token[0]
      }, (error,data)->
        console.log(error)
        cb()
    else
      tqq.t.add {
        content:content,
        clientip:"115.193.182.232",
        openid:token[1],
        access_token:token[0]
      }, (error,data)->
        console.log(error)
        cb()
  if type=="renren"
    if pic
      renren.photos.upload {
        upload:pic,
        caption:content,
        access_token:token
      }, (error,data)->
        console.log(error)
        cb()
    else
      renren.status.set {
        status:content,
        access_token:token
      }, (error,data)->
        console.log(error)
        cb()
  if type=="douban"
    if pic
      douban.shuo.statuses {
        access_token:token,
        source:config.sdks.douban.app_key,
        text:content,
        image:pic
      },(error,data)->
        console.log(error)
        cb()
    else
      douban.shuo.statuses {
        access_token:token,
        source:config.sdks.douban.app_key,
        text:content
      },(error,data)->
        console.log(error)
        cb()
_timer: null
module.exports=
  test: ->
      postQueue.push
        content:"test1",
        pic:path.join(__dirname, "./../test.jpg")
        type:'sina'
        token:"2.00wVkPsB0kPDjGcb5104c462mM_CpC"
  start: ->
    await connectDb defer err
    timefunc= ->
      console.log "tick:#{Date.now()}"
      tick ->
        
        _timer=setTimeout timefunc,5000
    _timer=setTimeout timefunc,5000
 

  stop: ->
    clearTimeout _timer

module.exports.tick=tick= (cb)->
  query =
    content:
      $ne: ''
    time:
      $lte: new Date()
  await postSchedule.find(query).populate('user').exec defer err,items
  for item in items
    owner = item.user
    await postSchedule.remove item,defer err
    await fs.exists path.join(__dirname,'..','assets',"post#{item._id}.jpg"),defer picExists
    picPath=null
    if picExists
      picPath=path.join(__dirname,'..','assets',"post#{item._id}.jpg")
    if owner.sinaToken?
      postQueue.push
        content: item.content
        pic: picPath
        type: 'sina'
        token: owner.sinaToken
    if owner.doubanToken?
      postQueue.push
        content: item.content
        pic: picPath
        type: 'douban'
        token: owner.doubanToken
    if owner.renrenToken?
      postQueue.push
        content: item.content
        pic: picPath
        type: 'renren'
        token: owner.renrenToken
    if owner.qqToken.length
      postQueue.push
        content: item.content
        pic: picPath
        type: 'qq'
        token: owner.qqToken

  if postQueue.length!=0
    console.log("queue noempty")
    post = postQueue.shift()
    console.log post
    await sendSNS post.content,post.pic,post.type,post.token, defer()
  cb()


