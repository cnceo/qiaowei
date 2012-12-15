mongoose           = require 'mongoose'
userSchema         = new mongoose.Schema
  name             : 
    type           : String
    required       : true

  sinaToken        : String
  renrenToken      : String
  doubanToken      : String
  qqToken          : [String]
  
  editorsOf        :[
    type           : mongoose.Schema.Types.ObjectId
    ref            : 'org'
  ]
  posterOf         :[
    type           : mongoose.Schema.Types.ObjectId
    ref            : 'org'
  ]
  owns             : [
    type           : mongoose.Schema.Types.ObjectId
    ref            : 'org'
  ]


orgSchema          = new mongoose.Schema
  owner            : 
    type           : mongoose.Schema.Types.ObjectId
    ref            : 'user'
  posters          : [
    type           : mongoose.Schema.Types.ObjectId
    ref            : 'user'
  ]
  editors          : [
    type           : mongoose.Schema.Types.ObjectId
    ref            : 'user'
  ]
  postSchedules    :[
    type           : mongoose.Schema.Types.ObjectId,
    ref            : 'postSchedule'
  ]
  contents         : [
    type           : mongoose.Schema.Types.ObjectId,
    ref            : 'content'
  ]


postScheduleSchema = new mongoose.Schema
  time             :
    type           : Date
    required       : true
  interval         :
    type           : Number
    required       : true
  contents         : [contentSchema]

contentSchema      = new mongoose.Schema
  _user            :
    type           : mongoose.Schema.Types.ObjectId
    ref            : 'user'
  content          :
    type           : String

module.exports     =
  org              : mongoose.model 'org',orgSchema
  postSchedule     : mongoose.model 'postSchedule',postScheduleSchema
  content          : mongoose.model 'content',contentSchema
  user             : mongoose.model 'user',userSchema 
  connectDb        : (cb)->
    mongoose.connect 'mongodb://localhost/qiaowei-db',cb