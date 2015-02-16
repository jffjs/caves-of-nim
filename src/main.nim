import libtcod, game as g

var game = newGame()

game.render()
while not (consoleIsWindowClosed() or game.exit):
  var key = consoleWaitForKeypress(true);
  if key.vk == K_ESCAPE:
    game.exit = true

  game.update(key)
  game.render()
