Class {
	#name : #OPLayoutWizard,
	#superclass : #WizardControl,
	#instVars : [
		'controller',
		'elements',
		'undirectedEdges',
		'directedEdges',
		'toNumberBlock'
	],
	#category : #'OpenPonk-Spec-Wizards'
}

{ #category : #options }
OPLayoutWizard >> addOptionsFor: aClass to: aPane [
	(aClass isKindOf: RTAbstractGraphLayout class)
		ifTrue: [ self optionsForAbstractGraphLayoutTo: aPane ].
	(aClass isKindOf: RTForceBasedLayout class)
		ifTrue: [ self optionsForForceBasedLayoutTo: aPane ].
	(aClass isKindOf: RTAbstractGridLayout class)
		ifTrue: [ self optionsForAbstractGridLayoutTo: aPane ].
	(aClass isKindOf: RTAbstractRegularTreeLayout class)
		ifTrue: [ self optionsForAbstractRegularTreeLayoutTo: aPane ]
]

{ #category : #adding }
OPLayoutWizard >> addPane [
	| pane layoutDropList |
	pane := WizardSinglePane new.
	layoutDropList := DropListPart new
		inGroupboxNamed: 'Layout algorithm';
		horizontalSize: 300;
		list: self layouts;
		format: [ :pair | pair value , ' layout' ];
		defaultValue: self layouts first;
		callback: [ :outputValue | 
			pane removeAllParts.
			pane addPart: layoutDropList associatedTo: #algorithm.
			self addOptionsFor: outputValue key to: pane.
			pane refresh ];
		yourself.
	pane row: layoutDropList associatedTo: #algorithm.
	self addPane: pane
]

{ #category : #'as yet unclassified' }
OPLayoutWizard >> applyLayoutWith: aDictionary [
	| algo keyPairs |
	algo := (aDictionary at: #algorithm) key new.
"	algo translator: (RTSmoothLayoutTranslator new nbCycles: 0.5)."
	(algo isKindOf: RTAbstractRegularTreeLayout)
		ifTrue: [ algo doNotAttachPoint ].
	keyPairs := aDictionary keys
		select: [ :each | each beginsWith: 'perform_' ]
		thenCollect: [ :each | each -> ((each withoutPrefix: 'perform_') , ':') asSymbol ].
	keyPairs
		do: [ :each | 
			(algo respondsTo: each value)
				ifTrue: [ | val |
					val := aDictionary at: each key.
					algo
						perform: each value
						with:
							(val isString
								ifTrue: [ val asNumber ]
								ifFalse: [ val ]) ] ].
	controller applyLayout: algo
]

{ #category : #accessing }
OPLayoutWizard >> controller [
	^ controller
]

{ #category : #accessing }
OPLayoutWizard >> controller: aDiagramController [
	controller := aDiagramController
]

{ #category : #accessing }
OPLayoutWizard >> directedEdges [
	^ directedEdges ifNil: [ #() ]
]

{ #category : #accessing }
OPLayoutWizard >> directedEdges: aCollection [
	directedEdges := aCollection
]

{ #category : #accessing }
OPLayoutWizard >> edges [
	^ self directedEdges , self undirectedEdges
]

{ #category : #accessing }
OPLayoutWizard >> elements [
	^ elements ifNil: [ ^ #() ]
]

{ #category : #accessing }
OPLayoutWizard >> elements: aCollection [
	elements := aCollection
]

{ #category : #'initialize-release' }
OPLayoutWizard >> initialize [
	super initialize.
	toNumberBlock := [ :val | val ].
	self addPane.
	self atEndDo: [ :values | self applyLayoutWith: values ]
]

{ #category : #accessing }
OPLayoutWizard >> layouts [
	^ {RTSugiyamaLayout -> 'Sugiyama'.
	RTClusterLayout -> 'Cluster'.
"	RTForceBasedLayout -> 'Force-based'."
	RTTreeLayout -> 'Tree'.
	RTDominanceTreeLayout -> 'Dominance Tree'.
	RTRadialTreeLayout -> 'Radial Tree'.
	RTGridLayout -> 'Grid'.
	RTCellLayout -> 'Cell'}
]

{ #category : #options }
OPLayoutWizard >> optionsForAbstractGraphLayoutTo: aPane [
	aPane
		addPart:
			(TextFieldPart new
				inGroupboxNamed: 'Horizontal gap';
				defaultValue: '50';
				transformed: toNumberBlock)
		associatedTo: #perform_horizontalGap.
	aPane
		addPart:
			(TextFieldPart new
				inGroupboxNamed: 'Vertical gap';
				defaultValue: '50';
				transformed: toNumberBlock)
		associatedTo: #perform_verticalGap.
	aPane
		condition: [ :dict | NumberParser isNumber: (dict at: #perform_horizontalGap) ]
		named: 'Horizontal gap must be a number.'.
	aPane
		condition: [ :dict | NumberParser isNumber: (dict at: #perform_verticalGap) ]
		named: 'Vertical gap must be a number.'
]

{ #category : #options }
OPLayoutWizard >> optionsForAbstractGridLayoutTo: aPane [
	aPane
		addPart:
			(TextFieldPart new
				inGroupboxNamed: 'Gap size';
				defaultValue: '50';
				transformed: toNumberBlock)
		associatedTo: #perform_gapSize.
	aPane
		condition: [ :dict | NumberParser isNumber: (dict at: #perform_gapSize) ]
		named: 'Gap size must be a number.'
]

{ #category : #options }
OPLayoutWizard >> optionsForAbstractRegularTreeLayoutTo: aPane [
	aPane
		addPart:
			(CheckboxPart new
				inGroupboxNamed: 'Layered';
				label: 'Is layered';
				defaultValue: false)
		associatedTo: #perform_isLayered
]

{ #category : #options }
OPLayoutWizard >> optionsForForceBasedLayoutTo: aPane [
	aPane
		addPart:
			(TextFieldPart new
				inGroupboxNamed: 'Charge';
				defaultValue: '-300';
				transformed: toNumberBlock)
		associatedTo: #perform_charge.
	aPane
		condition: [ :dict | NumberParser isNumber: (dict at: #perform_charge) ]
		named: 'Charge must be a number.'
]

{ #category : #accessing }
OPLayoutWizard >> undirectedEdges [
	^ undirectedEdges ifNil: [ #() ]
]

{ #category : #accessing }
OPLayoutWizard >> undirectedEdges: anObject [
	undirectedEdges := anObject
]
