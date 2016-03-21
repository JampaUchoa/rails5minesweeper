App.games = App.cable.subscriptions.create("GamesChannel", {
  connected: function() {
      $("#start-game").removeClass("hidden");
    },
  disconnected: function() {

    },
  received: function(data) {
    return alert(data.message);
  }

});
