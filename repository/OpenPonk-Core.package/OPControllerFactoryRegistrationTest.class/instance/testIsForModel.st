running
testIsForModel
	registration := OPControllerFactoryRegistration new modelClass: OPTestEntityModel.
	self assert: (registration isForModel: OPTestEntityModel new).
	self deny: (registration isForModel: OPTestRelationModel new)