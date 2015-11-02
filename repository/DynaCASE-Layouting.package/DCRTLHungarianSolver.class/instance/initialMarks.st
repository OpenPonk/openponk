private
initialMarks
	matrix
		withIndicesDo:
			[ :value :row :column | 
			value = 0 & (rowCovers at: row) not & (columnCovers at: column) not
				ifTrue:
					[ marks at: row at: column put: self star.
					rowCovers at: row put: true.
					columnCovers at: column put: true ] ].
	rowCovers atAllPut: false