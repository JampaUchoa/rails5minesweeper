$(document).ready(function () {

$("#start-game").click(function () {
  App.games.perform("find_match");
  $(this).addClass("hidden");
  $("#searching-game").removeClass("hidden");
});

$( ".middle" ).on( "click", ".fog", function() {
  x = parseInt($(this).attr("data-x"));
  y = parseInt($(this).attr("data-y"));
  App.games.perform("move", {x: x, y: y});
});

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
