App.games = App.cable.subscriptions.create("GamesChannel", {
  connected: function() {
    return $("#start-game").removeClass("hidden");
    },
  disconnected: function() {

    },
  received: function(data) {
    if (data.context == "game_start") {
      $("#searching-game").addClass("hidden");
      str = "";
      for (i = 0; i < data.size_y; i++){
        str = str + "<tr>";
        for (j = 0; j < data.size_x; j++){
          str = str + "<td class='fog' data-x='"+ j +"' data-y='"+ i +"'> </td>";
        }
        str = str + "</tr>";
      }
      $("#game").append(str);
    }
    if (data.context == "board_reveal") {
      field = $(".fog[data-x='"+ data.pos_x +"'][data-y='"+ data.pos_y +"']");
      $(field).addClass("swept");
      $(field).removeClass("fog");
      if (data.field_obj == "b") {
        $(field).text("💣");
      } else{
        if (data.field_obj != "0"){
          $(field).text(data.field_obj);
        }
        else{
          $(field).text("");
        }
      }
    }
    if (data.context == "game_end") {
      $("#start-game").removeClass("hidden");
      $("#game-end").removeClass("hidden");
      if (data.winner == "you"){
        $(".you-win").removeClass("hidden");
      }
      else{
        $(".opponent-win").removeClass("hidden");
      }
    }
    if (data.context == "your_turn") {
      if (data.stat == "start"){
        $("#game").addClass("active");
      }
      else{
        $("#game").removeClass("active");
      }
    }
    if (data.context == "point") {
      if (data.stat == "you"){
        counter = $(".bombs-count[data-player='self']")
        counter.text(parseInt(counter.text()) + 1);
      }
      else{
        counter = $(".bombs-count[data-player='opponent']")
        counter.text(parseInt(counter.text()) + 1);
      }
    }
  }
});
