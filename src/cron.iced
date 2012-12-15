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
  await postSchedule.find(query).populate('org').exec defer err,items
  for item in items
    await user.findById item.org.owner,defer err,owner
    await postSchedule.remove item,defer err
    await fs.exists path.join(__dirname,'..','assets',"post#{item._id}.jpg"),defer picExists
    picPath=null
    if picExists
      args=[]
      args.push path.join(__dirname,'..','assets',"post#{item._id}.jpg")
      await fs.exists path.join(__dirname,'..','assets',"org#{item.org._id}head.jpg"),defer headExists
      if headExists
        args.push path.join(__dirname,'..','assets',"org#{item.org._id}head.jpg")
      await fs.exists path.join(__dirname,'..','assets',"org#{item.org._id}foot.jpg"),defer footExists
      if footExists
        args.push path.join(__dirname,'..','assets',"org#{item.org._id}foot.jpg")
      args.push '-append'
      args.push path.join(__dirname,'..','assets',"post#{item._id}target.jpg")
      await im.convert args,defer err,stderr
      picPath=path.join(__dirname,'..','assets',"post#{item._id}target.jpg")
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
        token: owner.qqToken.join(',')

  if postQueue.length!=0
    console.log("queue noempty")
    post = postQueue.shift()
    console.log post
    await sendSNS post.content,post.pic,post.type,post.token, defer()
  cb()


