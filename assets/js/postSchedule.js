var TimeSelector=function(){
  
  var year,month,day
  var nowTime
  var checkDay=function(){
    var value=month.value*1;
    day.options.length=0;
    var d=0;
    if(value==1||value==3||value==5||value==7||value==8||value==10||value==12){
      while(d++<31){
        var varItem =new Option(d<10?"0"+d:d,d)  
        if(d==(nowTime.getDate())){
          varItem.selected=true;
        }
        day.options.add(varItem)
      }
    }else if(value==2){
      if (year.value%400 == 0 || (year.value%4 == 0 && year.value%100 != 0)){
        while(d++<28){
          var varItem =new Option(d<10?"0"+d:d,d)  
          if(d==(nowTime.getDate())){
            varItem.selected=true;
          }
          day.options.add(varItem)
        }
      }else{
        while(d++<29){
          var varItem =new Option(d<10?"0"+d:d,d)  
          if(d==(nowTime.getDate())){
            varItem.selected=true;
          }
          day.options.add(varItem)
        }
      }
    }else{
      while(d++<30){
        var varItem =new Option(d<10?"0"+d:d,d)  
        if(d==(nowTime.getDate())){
          varItem.selected=true;
        }
        day.options.add(varItem)
      }
    } 
                    
  }
  return {
    init:function(){
       nowTime=new Date()
      for(var i=0;i<24;i++){
        var varItem = new Option(i, i);      
        if(i==nowTime.getHours()){
          varItem.selected=true;
        }
        $("#hour")[0].options.add(varItem);     
      }
      for(var i=0;i<60;i++){
        var varItem = new Option(i, i);      
        if(i==nowTime.getMinutes()){
          varItem.selected=true;
        }
        $("#minute")[0].options.add(varItem);     
      }
      for(var i=2012;i<2022;i++){
        var varItem = new Option(i, i);      
        if(i==nowTime.getYear()){
          varItem.selected=true;
        }
        $("#year")[0].options.add(varItem);     
      }
      for(var i=1;i<=12;i++){
        var varItem = new Option(i, i);      
        if(i==(nowTime.getMonth()+1)){
          varItem.selected=true;
        }
        $("#month")[0].options.add(varItem);     
      }
      year=$("#year")[0]
      month=$("#month")[0]
      day=$("#day")[0]
       checkDay()
      $("#year").change(function(e){
        checkDay()
      })
      $("#month").change(function(e){
        checkDay()
      })
    }
  }
}();


var PS=function(){
  
  return {
    init:function(){
      TimeSelector.init();
      this._bind()
    },
    _bind:function(){
      $(".col_pic").mouseenter(function(){
            $(this).addClass("hover")
            var pos=$(this).offset()
            $("#bigpic").css({
                left:pos.left+90,
                top:pos.top,
                display:"block"  
            }).html("<img src='"+$("img",this).attr("src")+"' />")
        })
        $(".col_pic").mouseleave(function(){
            $(this).removeClass("hover")
            $("#bigpic").css({
                display:"none"  
            })
        })
        $("#ku").change(function(){
          $("#source").val(this.value)
        })
    }
  }
}();