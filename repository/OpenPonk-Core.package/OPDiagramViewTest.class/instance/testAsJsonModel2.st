tests
testAsJsonModel2
	view := OPDiagramView new model: OPTestContainerModel new.
	self
		assert: (STON fromString: view asJson)
		equals:
			(STON
				fromString:
					'{"filters": [],"visibleElements" : [ ], "options" : {  },
					"modelName" : "container",
					"modelType" : "OPTestContainerModel"
}')