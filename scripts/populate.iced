models = require '../src/models'
await models.connectDb defer err
await models.user.remove {},defer err
await models.content.remove {},defer err
await models.org.remove {},defer err
await models.postSchedule.remove {},defer err
await models.member.remove {},defer err
console.log 'ok'
# admin = new models.user
#   name: 'admin'
# org= new models.org
#   name: '某公司'
#   owner: admin
# admin.owns.push org

# admin.editorOf.push org
# org.editors.push admin

# await admin.save defer err
# for i in [1..5]
#   user= new models.user
#     name: "user#{i}"
#   user.editorOf.push org
#   await user.save defer err
#   org.editors.push org
#   await org.save defer err
  

# for i in [6..10]
#   user= new models.user
#     name: "user#{i}"
#   user.posterOf.push org
#   await user.save defer err
#   org.posters.push org
#   await org.save defer err

# for i in [1..3]
#   org.contents.push content = new models.content
#     content: "内容#{i}"
#   await content.save defer err
#   await org.save defer err


# for i in [1..2]
#   org.postSchedules.push postSchedule = new models.postSchedule
#     time: Date.now()
#     interval : 3000
#   await postSchedule.save defer err
#   await org.save defer err

# await org.save defer err

# console.log 'org:'
# await models.org.find {},defer err,items
# console.log items
# console.log 'user:'
# await models.user.find {},defer err,items
# console.log items
# console.log 'content:'
# await models.content.find {},defer err,items
# console.log items
# console.log 'postSchedule:'
# await models.postSchedule.find {},defer err,items
# console.log items
