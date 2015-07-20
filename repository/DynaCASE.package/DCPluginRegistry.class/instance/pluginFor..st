accessing
pluginFor: aDiagram
	^ plugins detect: [ :each | each diagramClass = aDiagram class ]