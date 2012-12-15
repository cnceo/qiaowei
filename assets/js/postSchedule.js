var nowTime=new Date()
for(var i=0;i<24;i++){
  var varItem = new Option(i, i);      
  if(i==nowTime.getHours()){
    varItem.selected=true;
  }
  DOM.get("#hour").options.add(varItem);     
}
for(var i=0;i<60;i++){
  var varItem = new Option(i, i);      
  if(i==nowTime.getMinutes()){
    varItem.selected=true;
  }
  DOM.get("#minute").options.add(varItem);     
}
for(var i=0;i<60;i++){
  var varItem = new Option(i, i);      
  if(i==0){
    varItem.selected=true;
  }
  DOM.get("#second").options.add(varItem);     
}
for(var i=2012;i<2022;i++){
  var varItem = new Option(i, i);      
  if(i==nowTime.getYear()){
    varItem.selected=true;
  }
  DOM.get("#year").options.add(varItem);     
}
for(var i=1;i<=12;i++){
  var varItem = new Option(i, i);      
  if(i==(nowTime.getMonth()+1)){
    varItem.selected=true;
  }
  DOM.get("#month").options.add(varItem);     
}
var year=DOM.get("#year")
var month=DOM.get("#month")
var day=DOM.get("#day")
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