running
testIsForModelWithCondition
	registration := OPControllerFactoryRegistration new
		modelClass: OPTestRelationModel;
		condition: [ :aModel | aModel source isNotNil ].
	self deny: (registration isForModel: OPTestRelationModel new).
	self assert: (registration isForModel: (OPTestRelationModel new source: 12))