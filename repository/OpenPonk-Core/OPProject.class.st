"
I represent a collection of diagrams and settings opened in editor.
"
Class {
	#name : #OPProject,
	#superclass : #Object,
	#instVars : [
		'uuid',
		'dirty',
		'storageFolder',
		'storageFile',
		'name',
		'modelsAndDiagrams'
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

{ #category : #comparing }
OPProject >> = anotherProject [

	^ self uuid = anotherProject uuid
]

{ #category : #accessing }
OPProject >> addDiagram: aDiagram [

	(self addModel: aDiagram modelElement) add: aDiagram
]

{ #category : #accessing }
OPProject >> addDiagrams: aCollection [
	aCollection do: [ :each | self addDiagram: each ]
]

{ #category : #adding }
OPProject >> addModel: aModel [

	| diagrams |
	diagrams := modelsAndDiagrams
		            at: aModel
		            ifAbsentPut: OrderedCollection new.
	(aModel respondsTo: #project:) ifTrue: [ aModel project: self ].
	^ diagrams
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

	^ modelsAndDiagrams flattened
]

{ #category : #accessing }
OPProject >> diagrams: aCollection [

	modelsAndDiagrams do: [ :each | each removeAll ].
	self addDiagrams: aCollection
]

{ #category : #removing }
OPProject >> diagramsOf: aModel [

	^ modelsAndDiagrams at: aModel ifAbsent: [ OrderedCollection new ]
]

{ #category : #adding }
OPProject >> ensureModelsHaveDiagrams [

	self addDiagrams: (self models
			 reject: [ :eachModel | self hasDiagramsModel: eachModel ]
			 thenCollect: [ :eachModel | 
			 OPOpenPonkDiagram forModelElement: eachModel ])
]

{ #category : #adding }
OPProject >> hasDiagramsModel: aModel [

	^ (modelsAndDiagrams at: aModel ifAbsent: [ ^ false ]) isNotEmpty
]

{ #category : #adding }
OPProject >> hasModel: aModel [

	^ self models includes: aModel
]

{ #category : #comparing }
OPProject >> hash [

	^ self uuid hash
]

{ #category : #initialization }
OPProject >> initialize [

	modelsAndDiagrams := Dictionary new asValueHolder.
	name := NewValueHolder value: 'Unnamed project'.
	dirty := false asValueHolder.
	modelsAndDiagrams whenChangedDo: [ dirty value: true ].
	name whenChangedDo: [ dirty value: true ]
]

{ #category : #'as yet unclassified' }
OPProject >> inspectionItems [

	<inspectorPresentationOrder: 100 title: 'Models and Diagrams'>
	| diagramsByModels |
	diagramsByModels := self modelsAndDiagrams.

	^ SpTreePresenter new
		  roots: diagramsByModels keys;
		  children: [ :each | diagramsByModels at: each ifAbsent: [ #(  ) ] ];
		  display: #name;
		  expandRoots;
		  yourself
]

{ #category : #operations }
OPProject >> mergeWith: aProject [

	| otherModels otherDiagrams |
	otherModels := aProject models.
	otherDiagrams := aProject diagrams.
	otherModels do: [ :each | aProject removeModel: each ].
	self addDiagrams: otherDiagrams
]

{ #category : #accessing }
OPProject >> models [

	^ modelsAndDiagrams keys
]

{ #category : #accessing }
OPProject >> modelsAndDiagrams [

	^ modelsAndDiagrams value
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

	modelsAndDiagrams
		at: aDiagram model
		ifPresent: [ :diagrams | diagrams remove: aDiagram ]
]

{ #category : #removing }
OPProject >> removeDiagramsOf: aModel [

	(modelsAndDiagrams at: aModel) removeAll
]

{ #category : #persistence }
OPProject >> removeFromImage [
	OPProjectStorage default remove: self
]

{ #category : #removing }
OPProject >> removeModel: aModel [

	modelsAndDiagrams removeKey: aModel.
	(aModel respondsTo: #announcer) ifTrue: [ 
		aModel announcer unsubscribe: self ].
	(aModel respondsTo: #project:) ifTrue: [ aModel project: nil ]
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
	storageFile := anObject.
	^ storageFile
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

{ #category : #announcements }
OPProject >> unsubscribe: aSubscriber [

	dirty announcer unsubscribe: aSubscriber
]

{ #category : #accessing }
OPProject >> uuid [

	^ uuid ifNil: [ uuid := UUID new ]
]

{ #category : #accessing }
OPProject >> uuid: aUUID [
	uuid := aUUID
]

{ #category : #announcements }
OPProject >> whenChanged: aBlock [

	dirty announcer when: ValueChanged do: aBlock
]
