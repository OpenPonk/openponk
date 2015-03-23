diagram handling
newDiagramControllerFor: aDiagram
	| diagramControllers |
	diagramControllers := Dictionary new.
	DCDiagramController allSubclasses do: [ :each | diagramControllers at: each modelClass put: each ].
	diagramControllers
		at: aDiagram class
		ifPresent: [ :class | 
			^ class new
				model: aDiagram;
				editor: self;
				yourself ]
		ifAbsent: [ self error: 'Unknown diagram type' ]