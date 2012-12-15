mongoose           = require 'mongoose'
userSchema         = new mongoose.Schema
  name             : 
    type           : String
    required       : true
  postSchedules    :[
    type           : mongoose.Schema.Types.ObjectId,
    ref            : 'postSchedule'
  ]
  contents         : [
    type           : mongoose.Schema.Types.ObjectId,
    ref            : 'content'
  ]
  sources          : [
    type           : mongoose.Schema.Types.ObjectId,
    ref            : 'postSchedule'
  ]


postScheduleSchema = new mongoose.Schema
  _user            :
    type           : mongoose.Schema.Types.ObjectId
    ref            : 'user'
  time             :
    type           : Date
    required       : true
  interval         :
    type           : Number
    required       : true
  contents         : [contentSchema]
  sources          : [sourceSchema]

contentSchema      = new mongoose.Schema
  _user             :
    type           : mongoose.Schema.Types.ObjectId
    ref            : 'user'
  content          :
    type           : String

sourceSchema       = new mongoose.Schema
  _user             :
    type           : mongoose.Schema.Types.ObjectId
    ref            : 'user'
  url              :
    type           : String 

module.exports     =
  postSchedule     : mongoose.model 'postSchedule',postScheduleSchema
  content          : mongoose.model 'content',contentSchema
  source           : mongoose.model 'source',sourceSchema
  user             : mongoose.model 'user',userSchema 
  connectDb        : (cb)->
    mongoose.connect 'mongodb://localhost/qiaowei-db',cb