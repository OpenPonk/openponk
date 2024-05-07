"
I represent camera positioning over the view.
"
Class {
	#name : 'OPLegacyDiagramCamera',
	#superclass : 'Object',
	#instVars : [
		'offset',
		'zoom'
	],
	#category : 'OpenPonk-Core-Diagrams',
	#package : 'OpenPonk-Core',
	#tag : 'Diagrams'
}

{ #category : 'testing' }
OPLegacyDiagramCamera class >> isDeprecated [
	"no longer tested and used"

	^ true
]

{ #category : 'accessing' }
OPLegacyDiagramCamera class >> neoJsonMapping: mapper [
	mapper
		for: self
			do: [ :mapping | 
			mapping mapInstVars.
			(mapping mapInstVar: #offset) valueSchema: Point ];
		mapInstVarsFor: Point
]

{ #category : 'accessing' }
OPLegacyDiagramCamera >> offset [
	^ offset
]

{ #category : 'accessing' }
OPLegacyDiagramCamera >> offset: anObject [
	offset := anObject
]

{ #category : 'accessing' }
OPLegacyDiagramCamera >> position [
	^ self offset
]

{ #category : 'accessing' }
OPLegacyDiagramCamera >> scale [
	^ self zoom
]

{ #category : 'accessing' }
OPLegacyDiagramCamera >> zoom [
	^ zoom
]

{ #category : 'accessing' }
OPLegacyDiagramCamera >> zoom: anObject [
	zoom := anObject
]
