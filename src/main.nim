import libtcod

var
  width = 80
  height = 50
  renderer = RENDERER_SDL
  fullscreen = false
  exit = false

consoleInitRoot(width, height, "caves of nim", fullscreen, renderer)

while not (consoleIsWindowClosed() or exit):
  consoleClear(nil)
  consolePutChar(nil, 40, 25, '@', BKGND_SET)
  consoleFlush()
  var key = consoleWaitForKeypress(true);
  if key.vk == K_ESCAPE:
    exit = true
