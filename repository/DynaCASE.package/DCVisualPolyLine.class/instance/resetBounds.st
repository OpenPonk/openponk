as yet unclassified
resetBounds
	self width: (self points detectMax: [ :pt | pt x ]) x.
	self height: (self points detectMax: [ :pt | pt y ]) y