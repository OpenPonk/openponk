accessing
cellSize
	^ cellSize ifNil: [ cellSize := self defaultCellSize ]