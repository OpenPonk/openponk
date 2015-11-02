private
minimizeRows
	1 to: size do: [ :i | self addToRowAt: i value: (matrix atRow: i) min negated ]