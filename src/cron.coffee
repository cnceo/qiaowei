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

postQueue = [{
content:"test1",
pic:path.join(__dirname, "./../test.jpg"),
sinaToken:"2.00wVkPsB0kPDjGcb5104c462mM_CpC"
}]
  
sendSNS= (content,pic,type,token)->
  if type=="sina"
    if pic
      sina.statuses.upload {status:content,pic:pic,access_token:token},(error,data)->
        console.log(error)
    else
      sina.statuses.update {status:content,access_token:token},(error,data)->
        console.log(error)
        
        
setInterval ->
  if postQueue.length!=0
    console.log("queue noempty")
    post=postQueue.shift()
    if post.sinaToken
      sendSNS post.content,post.pic,"sina",post.sinaToken
,5000 