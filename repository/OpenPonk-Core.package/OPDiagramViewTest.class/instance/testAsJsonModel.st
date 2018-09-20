tests
testAsJsonModel
	view := OPDiagramView new
		modelName: 'testComp';
		modelType: 'Component';
		modelVersion: '1.0'.
	self
		assert: (STON fromString: view asJson)
		equals:
			(STON
				fromString:
					'{"filters": [],"visibleElements" : [ ],"options": { },
					"modelName" : "testComp",
					"modelType" : "Component",
					"modelVersion" : "1.0"
}')