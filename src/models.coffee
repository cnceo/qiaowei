mongoose       = require 'mongoose'
userSchema     = mongoose.Schema
  name         : 
    type       : String
    required   : true
  schedules    :
    type       : [scheduleSchema]
    default    : []

scheduleSchema = mongoose.Schema
  time         :
    type       : Date
    required   : true
  interval     :
    type       : Number
    required   : true


module.exports =
  User         : mongoose.model 'User',userSchema
  Schedule     : mongoose.model 'Schedule',scheduleSchema

mongoose.connect 'mongodb://localhost/qiaowei-db', (err) ->
  if err
    console.error err
    return process.exit()
