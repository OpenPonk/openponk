Class {
	#name : #OPDiagramsReader,
	#superclass : #OPDiagramsPersistence,
	#category : #'OpenPonk-Spec-Views'
}

{ #category : #reading }
OPDiagramsReader >> defaultDiagramFor: aModel [
	^ self diagramClass defaultDiagramFor: aModel
]

{ #category : #writing }
OPDiagramsReader >> diagramsForModel: aModel project: aProject [
	| viewsDir views |
	viewsDir := self viewFolderForModel: aModel sourceBase: aProject storage sourceBase.
	views := {}.
	viewsDir isDirectory
		ifTrue: [ views := (viewsDir files select: [ :each | each extension = 'json' ])
				collect: [ :each | self diagramClass fromJsonString: each contents ] ].
	views := views
		select:
			[ :each | each modelType = aModel typeName & (each modelName = aModel name) & (each modelVersion = aModel version) ].
	(views noneSatisfy: [ :each | each isDefault ])
		ifTrue: [ views := views , {self defaultDiagramFor: aModel} ].
	^ views
]

{ #category : #reading }
OPDiagramsReader >> loadDiagramsOn: aProject [
	| views viewsInfo |
	views := aProject models
		flatCollect: [ :each | self diagramsForModel: each project: aProject ].
	viewsInfo := self
		readDiagramsInfoFromFile: (self applicationViewsFileFor: aProject).
	viewsInfo
		do: [ :info | 
			views
				detect: [ :view | info isForDiagram: view ]
				ifFound: [ :view | view updateFromInfo: info ] ].
	aProject views: views.
	^ views
]

{ #category : #writing }
OPDiagramsReader >> readDiagramsInfo: aString [
	^ (NeoJSONReader on: aString readStream)
		mapInstVarsFor: OPDiagramInfo;
		for: #List customDo: [ :mapping | mapping listOfElementSchema: OPDiagramInfo ];
		nextAs: #List
]

{ #category : #writing }
OPDiagramsReader >> readDiagramsInfoFromFile: aFileReference [
	aFileReference isFile & aFileReference isReadable
		ifFalse: [ ^ {} ].
	^ self readDiagramsInfo: aFileReference contents
]
