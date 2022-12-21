Class {
	#name : #OPDIStyle,
	#superclass : #Object,
	#instVars : [
		'styledElements',
		'properties'
	],
	#category : #'OpenPonk-Core-DiagramInterchange'
}

{ #category : #testing }
OPDIStyle class >> isAbstract [
	^ self = OPDIStyle
]

{ #category : #accessing }
OPDIStyle >> addedAsLocalToStyledElement: aDiagramElement [

	aDiagramElement localStyle = self ifFalse: [ 
		'This style was not added as local style to the element' ].
	styledElements ifNotEmpty: [ 
		self error: 'Cannot use style as local if already used elsewhere' ].
	styledElements add: aDiagramElement
]

{ #category : #accessing }
OPDIStyle >> addedAsSharedToStyledElement: aDiagramElement [

	aDiagramElement sharedStyle = self ifFalse: [ 
		'This style was not added as shared style to the element' ].
	(styledElements size = 1 and: [ 
		 styledElements anyOne localStyle == self ]) ifTrue: [ 
		self error: 'Cannot use style as shared if already used as local' ].
	styledElements add: aDiagramElement
]

{ #category : #accessing }
OPDIStyle >> at: aSymbol [

	^ properties at: aSymbol
]

{ #category : #accessing }
OPDIStyle >> at: aSymbol ifAbsent: aBlock [

	^ properties at: aSymbol ifAbsent: aBlock
]

{ #category : #accessing }
OPDIStyle >> at: aSymbol ifPresent: aBlock [

	^ properties at: aSymbol ifPresent: aBlock
]

{ #category : #accessing }
OPDIStyle >> at: aSymbol put: aValue [
	properties at: aSymbol put: aValue
]

{ #category : #initialization }
OPDIStyle >> initialize [

	super initialize.
	styledElements := Set new.
	properties := Dictionary new
]

{ #category : #removing }
OPDIStyle >> removeKey: aSymbol [
	^ properties removeKey: aSymbol
]

{ #category : #accessing }
OPDIStyle >> removedFromStyledElement: aDiagramElement [

	styledElements remove: aDiagramElement
]

{ #category : #accessing }
OPDIStyle >> styledElements [

	^ styledElements
]
