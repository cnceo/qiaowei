mongoose           = require 'mongoose'
userSchema         = new mongoose.Schema
  name             : 
    type           : String
    required       : true
    unique         : true

  sinaToken        : String
  renrenToken      : String
  renrenName       : String
  doubanToken      : String
  doubanName       : String
  qqToken          : [String]
  qqName           : String 
  owns             : [
    type           : mongoose.Schema.Types.ObjectId
    ref            : 'org'
  ]
  postSchedules    :[
    type           : mongoose.Schema.Types.ObjectId,
    ref            : 'postSchedule'
  ]
memberSchema       = new mongoose.Schema
  name             : String
  org              : 
    type           : mongoose.Schema.Types.ObjectId
    ref            : 'org'


orgSchema          = new mongoose.Schema
  title            : 
    type           : String
    default        : '公司名称'
  owner            : 
    type           : mongoose.Schema.Types.ObjectId
    ref            : 'user'

  members          : [
    type           : mongoose.Schema.Types.ObjectId
    ref            : 'member'
  ]
  contents         : [
    type           : mongoose.Schema.Types.ObjectId,
    ref            : 'content'
  ]


postScheduleSchema = new mongoose.Schema
  time             :
    type           : Date
    default        : Date.now
  interval         :
    type           : Number
    default        : 0
  content          :
    type           : String
    default        : ''
  retweet          : String
  user              : 
    type           : mongoose.Schema.Types.ObjectId
    ref            : 'user'

contentSchema      = new mongoose.Schema
  _user            :
    type           : mongoose.Schema.Types.ObjectId
    ref            : 'user'
  content          : 
    type           : String
  org              : 
    type           : mongoose.Schema.Types.ObjectId
    ref            : 'org'
  creator          :
    type           : String


module.exports     =
  org              : mongoose.model 'org',orgSchema
  postSchedule     : mongoose.model 'postSchedule',postScheduleSchema
  content          : mongoose.model 'content',contentSchema
  user             : mongoose.model 'user',userSchema 
  member           :        mongoose.model 'member',memberSchema
  connectDb        : (cb)->
    mongoose.connect 'mongodb://localhost/qiaowei-db',cb