instance creation
matrixFor: a2DArray
	^ Matrix
		rows: a2DArray size
		columns: a2DArray anyOne size
		tabulate: [ :i :j | (a2DArray at: i) at: j ]