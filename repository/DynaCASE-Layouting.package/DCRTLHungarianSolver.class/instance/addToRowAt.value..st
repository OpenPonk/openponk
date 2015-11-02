helpers
addToRowAt: i value: aValue
	matrix atRow: i put: ((matrix atRow: i) collect: [ :each | each + aValue ])