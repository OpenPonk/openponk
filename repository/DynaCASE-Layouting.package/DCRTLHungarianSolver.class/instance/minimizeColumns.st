private
minimizeColumns
	1 to: size do: [ :j | self addToColumnAt: j value: (matrix atColumn: j) min negated ]