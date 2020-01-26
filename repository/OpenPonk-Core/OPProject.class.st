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

{ #category : #adding }
OPProject >> addDefaultDiagramFor: aModel [
	self diagrams
		add: ((OPDiagram defaultDiagramFor: aModel) project: self)
]

{ #category : #adding }
OPProject >> addModel: aModel [
	models add: aModel.
	self addDefaultDiagramFor: aModel.
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
	^ diagrams
]

{ #category : #accessing }
OPProject >> diagrams: aCollection [
	diagrams
		removeAll;
		addAll: aCollection
]

{ #category : #initialization }
OPProject >> initialize [
	uuid := UUID new.
	models := OrderedCollection new asValueHolder.
	diagrams := OrderedCollection new.
	name := NewValueHolder value: 'Unnamed project'.
	dirty := false asValueHolder.
	models whenChangedDo: [ dirty value: true ].
	name whenChangedDo: [ dirty value: true ].
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
OPProject >> removeDiagramsOf: aModel [
	diagrams removeAllSuchThat: [ :each | each model = aModel ]
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
	^ uuid
]

{ #category : #accessing }
OPProject >> uuid: aUUID [
	uuid := aUUID
]

{ #category : #announcements }
OPProject >> whenChanged: aBlock [
	dirty whenChangedDo: aBlock
]
