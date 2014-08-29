instance creation
openOn: aDiagram
	^ self new
		open;
		openDiagram: aDiagram;
		yourself