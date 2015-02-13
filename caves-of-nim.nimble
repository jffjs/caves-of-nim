[Package]
name          = "caves-of-nim"
version       = "0.1.0"
author        = "Jeff Smith"
description   = "Rogue-like game in Nim"
license       = "BSD"

srcDir        = "src"
bin           = "main"

[Deps]
Requires: "nim >= 0.10.0, libtcod-nim >= 0.97"
