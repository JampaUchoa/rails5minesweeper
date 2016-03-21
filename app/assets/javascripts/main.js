$(document).on('page:change', function () {

$(".fog").click(function () {
  x = parseInt($(this).attr("data-x"));
  y = parseInt($(this).attr("data-y"));
  sweep(y, x, this);
});

App.games.connected(function() {
  alert();
});

function clearBlank(y, x){
  for(i = -1; i <= 1; i++){
    pos_y = i + y;
    if (!boundCheck(pos_y)){
      continue;
    }
    for(j = -1; j <= 1; j++){
      pos_x = j + x;
      if (!boundCheck(pos_x)){
        continue;
      }
        if (!$("td[data-x='"+ pos_x +"'][data-y='"+ pos_y +"']").hasClass("swept")){
        console.log("Triyng " + pos_y + "," + pos_x);
        sweep(pos_y, pos_x);
      }
    }
  }
}

function boundCheck(coord){
  coord < size && coord >= 0;
}

function sweep(y, x, space){
  field = game[y][x];

  $(space).addClass("swept");
  $(space).removeClass("fog");

  if (field == "b"){
    $(space).text("💣");
  }
  else {
    fieldNum = parseInt(field)
    if (field == 0){
      $(space).text("");
      clearBlank(y, x);
    }
    else {
      $(space).text(fieldNum);
      $(space).addClass("warn-"+ fieldNum)
    }
  }

}

});
