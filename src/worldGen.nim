import libtcod, math, geom

type
  TileType* = enum
    OutOfBounds,
    CaveFloor,
    CaveWall,

  Tile* = object
    glyph*: char
    foreColor*: TColor
    backColor*: TColor
    solid*: bool
    tileType*: TileType
      
proc newTile*(tileType: TileType, glyph: char, fColor: TColor, bColor: TColor, solid: bool): Tile =
  Tile(tileType: tileType, glyph: glyph, foreColor: fColor, backColor: bColor, solid: solid)

proc outOfBounds*(): Tile =
  Tile(glyph: 'X', foreColor: RED, backColor: BLACK, solid: true, tileType: OutOfBounds)

proc newCaveWall(): Tile =
  newTile(CaveWall, '\177', LIGHT_GREY, BLACK, true)

proc newCaveFloor(): Tile =
  newTile(CaveFloor, '\250', LIGHT_GREY, BLACK, false)

proc caves*(bounds: Rectangle, smooth: int): seq[seq[Tile]] =
  randomize()
  let
    maxX = bounds.width
    maxY = bounds.height

  var tiles: seq[seq[Tile]] = @[]
  for x in 0..maxX:
    var col: seq[Tile] = @[]
    for y in 0..maxY:
      let tile =
        if random(1000) >= 500:
          newCaveFloor()
        else:
          newCaveWall()
      col.add(tile)
    tiles.add(col)

  for i in 0..smooth:
    var sTiles: seq[seq[Tile]] = @[]
    for x in 0..maxX:
      var col: seq[Tile] = @[]
      for y in 0..maxY:
        var
          walls = 0
          floors = 0
          p = newPoint(x, y)
          adjTiles = p.adjacent()
        if tiles[x][y].tileType == CaveFloor:
          floors += 1
        else:
          walls += 1

        for t in adjTiles:
          if bounds.contains(t):
            if tiles[t.x][t.y].tileType == CaveFloor:
              floors += 1
            else:
              walls += 1

        if floors >= walls:
          col.add newCaveFloor()
        else:
          col.add newCaveWall()
      sTiles.add col            
    tiles = sTiles

  result = tiles
      
    
    
