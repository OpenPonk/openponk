helpers
padWithZeros: aMatrix
	| max padded |
	max := aMatrix numberOfRows max: aMatrix numberOfColumns.
	padded := Matrix rows: max columns: max element: 0.
	aMatrix withIndicesDo: [ :value :row :col | padded at: row at: col put: value ].
	^ padded