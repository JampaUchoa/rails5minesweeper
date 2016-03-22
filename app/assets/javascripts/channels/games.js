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
      for (i = 0; i < data.size_x; i++){
        str = str + "<tr>";
        for (j = 0; j < data.size_y; j++){
          str = str + "<td class='fog' data-x='"+ j +"' data-y='"+ i +"'> </td>";
        }
        str = str + "</tr>";
      }
      $("#game").append(str);
    }
    if (data.context == "board_reveal") {
      console.log("k");
      field = $(".fog[data-x='"+ data.pos_x +"'][data-y='"+ data.pos_y +"']");
      console.log("k");
      $(field).addClass("swept");
      $(field).removeClass("fog");
      if (data.field_obj == "b") {
        $(field).text("💣");
      } else{
        $(field).text(data.field_obj);
      }
    }
  }
});
