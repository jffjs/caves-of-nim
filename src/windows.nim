import libtcod, geom

type
  Window* = object
    console*: PConsole
    backgroundColor*: TColor
    bounds*: Rectangle

proc newWindow*(bounds: Rectangle): Window =
  let console = console_new(bounds.width, bounds.height)
  Window(console: console, backgroundColor: BLACK, bounds: bounds)

proc clear*(w: var Window) =
  console_set_default_background(w.console, w.backgroundColor)
  console_clear(w.console)

proc print*(w: var Window, x, y: int, s: string) =
  console_print_ex(w.console, x, y, BKGND_SET, LEFT, s)

proc render*(w: var Window, s: string) =
  w.clear()
  w.print(0, 0, s)
  console_blit(w.console, 0, 0, w.bounds.width, w.bounds.height, nil, w.bounds.left, w.bounds.top)

var
  mapWindow* = newWindow(newRectangle(0, 0, 59, 48))
  menuWindow* = newWindow(newRectangle(60, 0, 20, 49))
