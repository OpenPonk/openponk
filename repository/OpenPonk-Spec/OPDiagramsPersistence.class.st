Class {
	#name : #OPDiagramsPersistence,
	#superclass : #Object,
	#instVars : [
		'sourceBase'
	],
	#category : #'OpenPonk-Spec-Views'
}

{ #category : #versions }
OPDiagramsPersistence class >> version [
	^ '1.0.0'
]

{ #category : #versions }
OPDiagramsPersistence class >> versionMap [
	^ {'openponk' -> OPVersion fullVersion.
	'serializer' -> self version} asDictionary
]

{ #category : #'accessing - filesystem' }
OPDiagramsPersistence >> applicationViewsFileFor: aProject [
	^ aProject storage sourceBase / 'applications'
		/ aProject rootApplication shortName asFileName / 'views' / 'views.json'
]

{ #category : #'accessing - filesystem' }
OPDiagramsPersistence >> fileNameForView: aView sourceBase: aSourceBase [
	| modelFolder |
	modelFolder := self viewFolderForModel: aView model sourceBase: aSourceBase.
	modelFolder ensureCreateDirectory.
	^ modelFolder / aView name asFileName , 'json'
]

{ #category : #accessing }
OPDiagramsPersistence >> viewClass [
	^ OPDiagram
]

{ #category : #'accessing - filesystem' }
OPDiagramsPersistence >> viewFolderForModel: model sourceBase: aSourceBase [
	| componentFolder |
	componentFolder := aSourceBase / 'components' / model component name asFileName / 'views'.
	^ model isFlow
		ifTrue: [ componentFolder / 'flows' / model name asFileName ]
		ifFalse: [ componentFolder / 'component' ]
]
