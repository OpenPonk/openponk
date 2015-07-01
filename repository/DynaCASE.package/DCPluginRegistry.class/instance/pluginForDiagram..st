accessing
pluginForDiagram: aDiagram
	^ plugins detect: [ :each | each diagramClass = aDiagram class ]