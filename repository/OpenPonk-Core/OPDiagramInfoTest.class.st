Class {
	#name : #OPDiagramInfoTest,
	#superclass : #TestCase,
	#category : #'OpenPonk-Core-Diagrams'
}

{ #category : #tests }
OPDiagramInfoTest >> testIsForView [
	| info view |
	view := OPDiagram new
		name: 'default';
		modelType: 'Component';
		modelName: 'testComp';
		modelVersion: '1.0'.
	info := view asInfo.
	self assert: (info isForDiagram: view).
	info := view asInfo diagramName: 'other'.
	self deny: (info isForDiagram: view).
	info := view asInfo modelType: 'Flow'.
	self deny: (info isForDiagram: view).
	info := view asInfo modelName: 'otherComp'.
	self deny: (info isForDiagram: view).
	info := view asInfo modelVersion: '1.1'.
	self deny: (info isForDiagram: view)
]
