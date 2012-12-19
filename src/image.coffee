im = require 'imagemagick'
resizeTo440 = (file,cb)->
  args = []
  args.push file
  args.push "-resize"
  args.push 440
  args.push file
  im.convert args,(err,data)->
    cb err,data
resizeMain440 = (file,cb)->
  im.identify file,(err,data)->
    if err 
      cb err
    width = data.width
    height = data.height
    if width > 440
      args = []
      args.push file
      args.push "-resize"
      args.push 440
      args.push file
      im.convert args,(err, output)->
        cb err,output
    else
      args = []
      args.push file
      args.push "-size"
      args.push "440x"+(height+40)
      args.push "xc:white"
      args.push "+swap"
      args.push "-gravity"
      args.push "center"
      args.push "-composite"
      args.push file
      im.convert args,(err, output)->
        cb err,output
append = (fileList,target,cb)->
  args = []
  args = args.concat fileList
  args.push "-append"
  args.push target
  console.log args
  im.convert args,(err, output)->
    cb err,output
module.exports = 
  resizeTo440:resizeTo440
  resizeMain440:resizeMain440
  append:append