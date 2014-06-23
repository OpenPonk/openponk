accessing
resetBounds
	self position: (self pointHandles detectMin: [ :pt | (pt center )x ]) center x @ (self pointHandles detectMin: [ :pt | (pt center )y ]) center y.
	self width: ((self pointHandles detectMax: [ :pt | (pt center )x ]) center x - self  position x).
	self height: (self pointHandles detectMax: [ :pt | (pt center )y ]) center y- self  position y