import math

type
  Point = object
    x: int
    y: int
  Bounds = object
    min: Point
    max: Point

proc distance(p1: Point, p2: Point): float =
  result = sqrt(float((p2.x - p1.x) * (p2.x - p1.x) + (p2.y - p1.y) * (p2.y - p1.y)))

proc offsetX(p: Point, offset: int): Point =
  Point(x: p.x + offset, y: p.y)
      

when isMainModule:
  doAssert(distance(Point(x: 0, y: 1), Point(x: 0, y: 1)) == 0)
  doAssert(distance(Point(x: 0, y: 1), Point(x: 0, y: 2)) == 1)
  doAssert(distance(Point(x: 1, y: 1), Point(x: 2, y: 2)) > 1.41)
  doAssert(distance(Point(x: 1, y: 1), Point(x: 2, y: 2)) < 1.42)

  doAssert(offsetX(Point(x: 0, y: 0), 3) == Point(x: 3, y: 0))
  doAssert(offsetX(Point(x: 1, y: 0), -3) == Point(x: -2, y: 0))
    
