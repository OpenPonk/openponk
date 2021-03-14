"
I represent a collection of diagrams and settings opened in editor.
"
Class {
	#name : #OPProject,
	#superclass : #Object,
	#instVars : [
		'uuid',
		'dirty',
		'models',
		'storageFolder',
		'storageFile',
		'name',
		'diagrams'
	],
	#category : #'OpenPonk-Core-Models'
}

{ #category : #'instance creation' }
OPProject class >> name: aString [
	^ self new
		name: aString;
		yourself
]

{ #category : #'instance creation' }
OPProject class >> named: aString [
	^ self new
		name: aString;
		yourself
]

{ #category : #accessing }
OPProject >> addDiagram: aDiagram [
	(diagrams at: aDiagram model ifAbsentPut: [ OrderedCollection new ])
		add: aDiagram
]

{ #category : #accessing }
OPProject >> addDiagrams: aCollection [
	aCollection do: [ :each | self addDiagram: each ]
]

{ #category : #adding }
OPProject >> addModel: aModel [
	models add: aModel.
	(aModel respondsTo: #project:)
		ifTrue: [ aModel project: self ]
]

{ #category : #announcements }
OPProject >> changed [
	dirty value: true
]

{ #category : #accessing }
OPProject >> controllerClass [
	^ OPProjectController
]

{ #category : #adding }
OPProject >> copyDiagram: aDiagram [
	| newDiagram |
	newDiagram := aDiagram newCopy.
	self addDiagram: newDiagram.
	^ newDiagram
]

{ #category : #descriptions }
OPProject >> descriptionName [
	<magritteDescription>
	^ MAStringDescription new
		accessor: #name;
		label: 'Name';
		beRequired;
		yourself
]

{ #category : #accessing }
OPProject >> diagrams [
	^ self models
		flatCollect: [ :eachModel | self diagramsOf: eachModel ]
]

{ #category : #accessing }
OPProject >> diagrams: aCollection [
	diagrams removeAll.
	self addDiagrams: aCollection
]

{ #category : #removing }
OPProject >> diagramsOf: aModel [
	^ diagrams at: aModel ifAbsent: [ #() ]
]

{ #category : #adding }
OPProject >> ensureModelsHaveDiagrams [
	self
		addDiagrams:
			(self models
				reject: [ :eachModel | self hasDiagramsModel: eachModel ]
				thenCollect: [ :eachModel | OPDiagram withWholeModel: eachModel ])
]

{ #category : #adding }
OPProject >> hasDiagramsModel: aModel [
	^ self diagrams anySatisfy: [ :any | any model = aModel ]
]

{ #category : #initialization }
OPProject >> initialize [
	uuid := UUID new.
	models := OrderedCollection new asValueHolder.
	diagrams := Dictionary new.	"SRToManyLink
		on: self
		slot: #diagrams
		oppositeSlot: #project."
	name := NewValueHolder value: 'Unnamed project'.
	dirty := false asValueHolder.
	models whenChangedDo: [ dirty value: true ].
	name whenChangedDo: [ dirty value: true ]
]

{ #category : #accessing }
OPProject >> models [
	^ models value
]

{ #category : #accessing }
OPProject >> name [
	^ name value
]

{ #category : #accessing }
OPProject >> name: aString [
	name := aString
]

{ #category : #removing }
OPProject >> removeDiagram: aDiagram [
	| diagramsOfModel |
	diagramsOfModel := diagrams at: aDiagram model.
	diagramsOfModel remove: aDiagram.
	diagramsOfModel ifEmpty: [ diagrams removeKey: aDiagram model ]
]

{ #category : #removing }
OPProject >> removeDiagramsOf: aModel [
	diagrams removeKey: aModel
]

{ #category : #persistence }
OPProject >> removeFromImage [
	OPProjectStorage default remove: self
]

{ #category : #removing }
OPProject >> removeModel: aModel [
	self removeDiagramsOf: aModel.
	models remove: aModel.
	aModel announcer unsubscribe: self.
	(aModel respondsTo: #project:)
		ifTrue: [ aModel project: nil ]
]

{ #category : #persistence }
OPProject >> saveInImage [
	OPProjectStorage default add: self
]

{ #category : #accessing }
OPProject >> storageFile [
	^ storageFile
]

{ #category : #accessing }
OPProject >> storageFile: anObject [
	storageFile := anObject
]

{ #category : #accessing }
OPProject >> storageFolder [
	"A folder where the project data is stored."

	^ storageFolder
]

{ #category : #accessing }
OPProject >> storageFolder: aFilePath [
	storageFolder := aFilePath
]

{ #category : #accessing }
OPProject >> uuid [
	^ uuid ifNil: [ ^ UUID new ]
]

{ #category : #accessing }
OPProject >> uuid: aUUID [
	uuid := aUUID
]

{ #category : #announcements }
OPProject >> whenChanged: aBlock [
	dirty whenChangedDo: aBlock
]
