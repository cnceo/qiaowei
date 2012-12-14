models                            = require './src/models'
assert                            = require 'assert'


# poking area!

describe 'models',->
  before (done)->
    models.connectDb done
  beforeEach (done)->
    models.user.remove {},(err)->
      models.content.remove {},(err)->
        models.source.remove {},(err)->
          models.postSchedule.remove {},(err)->
            console.error err if err
            user1                       = new models.user
              name                      : 'tangzx'
            content1                    = new models.content
              content                   : 'haha'
            schedule1                   = new models.postSchedule
              time                      : Date.now()
              interval                  : 1000
            user1.postSchedules.push schedule1
            user1.save (err)->
              schedule1.save (err)->
                done(err)

  describe 'models',->
    it 'works',(done)->
      models.postSchedule.find {},(err,item)->
        assert.equal item.length,1
        models.user.find({}).populate('postSchedules').exec (err,item)->
          assert.equal item.length,1
          assert.equal item[0].postSchedules.length,1
          done err