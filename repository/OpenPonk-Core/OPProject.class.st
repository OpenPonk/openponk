"
I represent a collection of diagrams and settings opened in editor.
"
Class {
	#name : #OPProject,
	#superclass : #Object,
	#instVars : [
		'uuid',
		'dirty',
		'fileName',
		'layouts',
		'models',
		'storageFolder',
		'storageFile',
		'state',
		'name',
		'views'
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
OPProject >> addDefaultViewFor: aModel [
	self views add: (OPDiagramView defaultViewFor: aModel)
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
OPProject >> fileName [
	^ fileName
]

{ #category : #accessing }
OPProject >> fileName: aFileName [
	fileName := aFileName
]

{ #category : #initialization }
OPProject >> initialize [
	uuid := UUID new.
	models := OrderedCollection new asValueHolder.
	state := Dictionary new.
	layouts := Dictionary new.
	name := NewValueHolder value: 'Unnamed project'.
	dirty := false asValueHolder.
	models whenChangedDo: [ dirty value: true ].
	name whenChangedDo: [ dirty value: true ].
	views := SRToManyLink on: self slot: #views oppositeSlot: #project
]

{ #category : #accessing }
OPProject >> layout: aLayout for: aModel [
	^ layouts at: aModel uuid asString put: aLayout
]

{ #category : #accessing }
OPProject >> layoutFor: aModel [
	^ layouts at: aModel uuid asString ifAbsent: [ Dictionary new ]
]

{ #category : #accessing }
OPProject >> layouts [
	^ layouts copy
]

{ #category : #accessing }
OPProject >> layouts: aLayoutDictionary [
	layouts := aLayoutDictionary copy
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

{ #category : #accessing }
OPProject >> projectName [
	self 
		deprecated: 'Use name instead'
		on: 	'22 July 2017' 
		in: 'Pharo-6.0-60508-'
		transformWith: '`@receiver projectName' 
						-> '`@receiver name'.
	^ self name
]

{ #category : #accessing }
OPProject >> projectName: aString [
	self
		deprecated: 'Use name: instead'
		on: '22 July 2017'
		in: 'Pharo-6.0-60508-'
		transformWith: '`@receiver projectName: `@arg' -> '`@receiver name: `@arg'.
	^ self name: aString
]

{ #category : #persistence }
OPProject >> removeFromImage [
	OPProjectStorage default remove: self
]

{ #category : #removing }
OPProject >> removeModel: aModel [
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

{ #category : #accessing }
OPProject >> views [
	^ views
]

{ #category : #accessing }
OPProject >> views: aCollection [
	views
		removeAll;
		addAll: aCollection
]

{ #category : #announcements }
OPProject >> whenChanged: aBlock [
	dirty whenChangedDo: aBlock
]
