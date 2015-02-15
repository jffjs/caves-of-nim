import queues, libtcod, math, geom, worldGen

type
  Map* = object
    bounds*: Rectangle
    viewOrigin*: Point
    tiles*: seq[seq[Tile]]

proc scrollX(map: Map, center: Point, viewPort: Rectangle): int =
  let
    screenWidth = viewPort.width
    worldWidth = map.bounds.width
    centerX = center.x
  max(0, min(centerX - int(screenWidth / 2), worldWidth - screenWidth))

proc scrollY(map: Map, center: Point, viewPort: Rectangle): int =
  let
    screenHeight = viewPort.height
    worldHeight = map.bounds.height
    centerY = center.y
  max(0, min(centerY - int(screenHeight / 2), worldHeight - screenHeight))

proc getTile*(map: Map, p: Point): Tile =
  if map.bounds.contains(p):
    result = map.tiles[p.x][p.y]
  else:
    result = outOfBounds()

proc findEmptyTile*(map: Map, pos: Point): Point =
  let tile = map.tiles[pos.x][pos.y]

  result = pos
  if not tile.solid:
    return
  else:
    var q = initQueue[Point](8)
    for ap in pos.adjacent():
      q.add ap
    while q.len > 0:
      let
        p = q.dequeue
        t = map.tiles[p.x][p.y]
      if not t.solid:
        if map.bounds.contains(p):
          result = p
          break
      else:
        for ap in p.adjacent():
          q.add ap

proc render*(map: var Map, viewPort: Rectangle, center: Point) =
  let
    startX = map.scrollX(center, viewPort)
    startY = map.scrollY(center, viewPort)
  map.viewOrigin = newPoint(startX, startY)
  for x in 0..viewPort.width:
    for y in 0..viewPort.height:
      let
        tx = x + startX
        ty = y + startY
        tile = map.getTile(newPoint(tx, ty))
      consolePutCharEx(nil, x, y, tile.glyph, tile.foreColor, tile.backColor)
