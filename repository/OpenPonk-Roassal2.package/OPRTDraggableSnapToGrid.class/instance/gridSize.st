accessing
gridSize
	^ gridSize ifNil: [ gridSize := self defaultGridSize ]