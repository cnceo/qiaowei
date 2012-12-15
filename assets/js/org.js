$("img").each(function(i,img){
  var image=new Image();
  image.onerror=function(){
    img.parentNode.innerHTML="暂无图片"
  }
  image.src=img.src
})