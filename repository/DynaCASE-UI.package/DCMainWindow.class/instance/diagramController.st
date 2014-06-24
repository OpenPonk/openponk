accessing
diagramController
	^ diagramController ifNil: [ diagramController := self defaultDiagramController ]