$("#head_pic").click(function(){
  $("#headThumb").css("display","block")
})
$("#foot_pic").click(function(){
  $("#footThumb").css("display","block")
})

$("img").each(function(i,img){
  var image=new Image();
  image.onerror=function(){
   img.parentNode.innerHTML="暂无图片"
  }
  image.src=img.src
})