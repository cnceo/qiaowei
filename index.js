require('coffee-script');//有这么一句，之后我们就可以随意引用coffee了
var server =require('./src/server');
var cron   =require('./src/cron');

if(process.argv[2]=='cron'){
  cron.start();
  process.on('SIGTERM',function(){
    cron.stop();
  });
}else{
  require('http').createServer(server).listen(server.get("port"),function(){
    console.log("Express server listening on port " + server.get("port"));
  });
} 

