tests
testCannotConnectByDefault
	self deny: (controller canBeSourceFor: nil).
	self deny: (controller canBeTargetFor: nil).