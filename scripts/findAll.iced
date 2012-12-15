models = require '../src/models'
await models.connectDb defer err
await models.user.find {},defer err,items
console.log items