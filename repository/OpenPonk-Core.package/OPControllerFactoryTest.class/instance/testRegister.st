tests
testRegister
	self deny: (factory hasControllerFor: OPTestEntityModel new).
	factory register: OPTestEntityController forModel: OPTestEntityModel.
	self assert: (factory hasControllerFor: OPTestEntityModel new)