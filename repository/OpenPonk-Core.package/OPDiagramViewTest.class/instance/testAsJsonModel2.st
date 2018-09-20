tests
testAsJsonModel2
	view := OPDiagramView new
		model:
			(NSMComponent new
				name: 'testComp';
				version: '1.0').
	self
		assert: (STON fromString: view asJson)
		equals:
			(STON
				fromString:
					'{"filters": [],"visibleElements" : [ ], "options" : {  },
					"modelName" : "testComp",
					"modelType" : "Component",
					"modelVersion" : "1.0"
}')