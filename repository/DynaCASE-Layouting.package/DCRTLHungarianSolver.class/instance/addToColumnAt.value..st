helpers
addToColumnAt: j value: aValue
	matrix atColumn: j put: ((matrix atColumn: j) collect: [ :each | each + aValue ])