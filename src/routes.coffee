module.exports= class Routes
  constructor: (app)->
    @mount app if app?
  mount: (app)->
    app.get '*',(req,res,next)->
      res.render 'index'