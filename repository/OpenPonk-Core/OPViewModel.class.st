"
Acts as the ViewModel for a specific model element within a project. 
Serves as the structural bridge and domain logic handler between the underlying model and any controllers or GUI (Spec presenters). 
Answers queries about the model (such as icons and available actions) without holding direct GUI references. 
Manages its model element's lifecycle (creation, deletion, parenting) independently of any diagram.
"
Class {
	#name : 'OPViewModel',
	#superclass : 'Object',
	#instVars : [
		'model',
		'registry',
		'parentViewModel',
		'announcer'
	],
	#category : 'OpenPonk-Core-ViewModels',
	#package : 'OpenPonk-Core',
	#tag : 'ViewModels'
}

{ #category : 'accessing' }
OPViewModel class >> commonModelClassPrefix [

	^ 'OP'
]

{ #category : 'instance creation' }
OPViewModel class >> forModel: aModel [

	^ self new
		  model: aModel;
		  yourself
]

{ #category : 'testing' }
OPViewModel class >> isAbstract [

	^ self = OPViewModel
]

{ #category : 'accessing' }
OPViewModel class >> modelClass [

	^ self subclassResponsibility
]

{ #category : 'comparing' }
OPViewModel >> = other [

	^ model = other model
]

{ #category : 'accessing' }
OPViewModel >> allChildren [
	"Recursively gathers all hierarchical children viewModels in a cycle-proof way, preserving top-down breadth-first (level-order) topological order. 
	 This ensures containers are rendered before their contents, and nodes before edges."

	| all seen queue |
	all := OrderedCollection new.
	seen := Set new.
	queue := OrderedCollection with: self.

	[ queue isNotEmpty ] whileTrue: [
			| current |
			current := queue removeFirst.
			current children do: [ :eachViewModel |
					| eachModel |
					eachModel := eachViewModel model.
					(seen includes: eachModel) ifFalse: [
							seen add: eachModel.
							all add: eachViewModel.
							queue addLast: eachViewModel ] ] ].
	^ all
]

{ #category : 'accessing' }
OPViewModel >> allChildrenModels [

	^ self allChildren collect: [ :each | each model ]
]

{ #category : 'private' }
OPViewModel >> announceRemoval [

	self announcer announce: (OPModelRemoved model: self model)
]

{ #category : 'accessing' }
OPViewModel >> announcer [
    ^ announcer ifNil: [ announcer := Announcer new ]
]

{ #category : 'converting' }
OPViewModel >> asViewModel [
	^ self
]

{ #category : 'construction' }
OPViewModel >> attachModelFrom: sourceViewModel to: targetViewModel [
	"do nothing by default"

	
]

{ #category : 'private' }
OPViewModel >> basicRemoveModel [
	"Specific domain model removal logic - removal from owner, disconnecting from peers, etc."

	^ self subclassResponsibility
]

{ #category : 'forms' }
OPViewModel >> buildEditorForm: aForm [

	aForm fromMagritteDescriptions: self magritteDescription
]

{ #category : 'accessing' }
OPViewModel >> children [
	"Returns viewmodels of model elements that are children of own model element hierarchically / by ownership.
	 Answers viewmodels of essentialChildrenModels as default. While essentialChildrenModels is often a subset of childrenModels, there might be essentialChildrenModels that may be important even if they are not owned by it.
	 Used for example for GUI tree representations of a model."
	
	^ self childrenModels
		collect: [ :eachModel | self registry viewModelFor: eachModel ]
]

{ #category : 'accessing' }
OPViewModel >> childrenModels [
	"Returns model elements that are children of own model element hierarchically / by ownership.
	 Answers essentialChildrenModels as default. While essentialChildrenModels is often a subset of childrenModels, there might be essentialChildrenModels that may be important even if they are not owned by it.
	 Used for example for GUI tree representations of a model."

	^ self essentialChildrenModels
]

{ #category : 'undo/redo' }
OPViewModel >> commandForProperty: aSymbol accessor: anAccessor oldValue: anOldValue newValue: aNewValue [
	"Subclasses may override to produce specialized reversible commands for specific properties."
	^ nil
]

{ #category : 'construction' }
OPViewModel >> createModelFrom: sourceViewModel to: targetViewModel in: aParentModel [

	self model: self modelClass new.
	self attachModelFrom: sourceViewModel to: targetViewModel.
	self registerModelIn: aParentModel.
	^ self model
]

{ #category : 'construction' }
OPViewModel >> createModelIn: aParentModel [

	self model: self modelClass new.
	self registerModelIn: aParentModel.
	^ self model
]

{ #category : 'accessing' }
OPViewModel >> creationPriority [
	^ 100
]

{ #category : 'accessing' }
OPViewModel >> dependentElements [
	"Returns model elements that are existentially dependent on own model element. For example associations from/to the model, items contained inside, etc.
	 Answers childrenModels as default. While childrenModels is often a subset of dependentElements, there might be childrenModels that may exist even without own model element.
	 Used for example for removal of dependencies before removing own model element."
	
	^ self childrenModels
]

{ #category : 'accessing' }
OPViewModel >> dependingOnElements [

	| parent |
	parent := self parentViewModel.
	parent ifNil: [ ^ Set empty ].
	parent model ifNil: [ ^ Set empty ].
	self projectViewModel = parent ifTrue: [ ^ Set empty ].
	^ Set with: parent model
]

{ #category : 'forms' }
OPViewModel >> descriptionAccessor: aSymbol [
	"Answer an OPModelPropertyAccessor preserving property name metadata."
	^ OPModelPropertyAccessor on: aSymbol
]

{ #category : 'forms' }
OPViewModel >> descriptionName [
	<magritteDescription>
	^ MAStringDescription new
		accessor: (self descriptionAccessor: #name);
		label: 'Name';
		priority: 1;
		yourself
]

{ #category : 'accessing' }
OPViewModel >> essentialChildrenModels [
	"Returns child or otherwise dependent model elements that are essential for own model (when talking about the parent, we should usually mention these model elements).
	 Used for example for automatically showing children in a digram when the own model element is added / shown."

	^ #(  )
]

{ #category : 'accessing' }
OPViewModel >> findParentViewModel [

	^ self subclassResponsibility
]

{ #category : 'forms' }
OPViewModel >> formEventsAnnouncer [

	^ self announcer
]

{ #category : 'comparing' }
OPViewModel >> hash [

	^ model hash
]

{ #category : 'accessing' }
OPViewModel >> icon [
	^ self subclassResponsibility
]

{ #category : 'accessing' }
OPViewModel >> model [

	^ model
]

{ #category : 'accessing' }
OPViewModel >> model: aModel [
    model := aModel.
    self subscribeToModel
]

{ #category : 'announcements' }
OPViewModel >> modelChanged [
	self announcer announce: OPModelChanged new
]

{ #category : 'accessing' }
OPViewModel >> modelClass [

	^ self class modelClass
]

{ #category : 'printing' }
OPViewModel >> modelDisplayString [
	^ String streamContents: [ :s | self modelDisplayStringOn: s ]
]

{ #category : 'printing' }
OPViewModel >> modelDisplayStringOn: aStream [
	"Provides the default display string: 'Name (Type)' or just 'Type' if name is empty"

	| modelName typeName |
	modelName := self nameOfModel.
	typeName := self nameOfType.

	modelName trim ifEmpty: [
			aStream nextPutAll: typeName.
			^ self ].

	aStream nextPutAll: modelName trim.
	aStream
		space;
		nextPut: $(;
		nextPutAll: typeName;
		nextPut: $)
]

{ #category : 'accessing' }
OPViewModel >> modelRootViewModel [

	self parentViewModel == self projectViewModel ifTrue: [ ^ self ].
	self parentViewModel ifNotNil: [ :p | ^ p modelRootViewModel ].
	^ self
]

{ #category : 'accessing' }
OPViewModel >> modelSource [
	^ (self model respondsTo: #source)
		ifTrue: [ self model source ]
		ifFalse: [ nil ]
]

{ #category : 'accessing' }
OPViewModel >> modelTarget [
	^ (self model respondsTo: #target)
		ifTrue: [ self model target ]
		ifFalse: [ nil ]
]

{ #category : 'accessing' }
OPViewModel >> modelType [

	| rawName |
	rawName := self model className withoutPrefix: self modelRootViewModel class commonModelClassPrefix.
	rawName ifEmpty: [ rawName := self model className withoutPrefix: OPViewModel commonModelClassPrefix ].
	rawName ifEmpty: [ rawName := self model className ].

	^ OPModelObjectType named: (rawName splitCamelCase joinUsing: ' ')
]

{ #category : 'printing' }
OPViewModel >> nameOfModel [

	^ (self model respondsTo: #name)
		  ifTrue: [ self model name ifNil: [ '' ] ]
		  ifFalse: [ '' ]
]

{ #category : 'accessing' }
OPViewModel >> nameOfType [

	^ self modelType printWithNameSeparator: ' ' subtypesSeparator: ' '
]

{ #category : 'actions' }
OPViewModel >> openEditorWithApplication: anApplication undoManager: anUndoManager [
	"Hook for domain editors opened from property forms. Subclasses override to launch specific editors."
	^ self
]

{ #category : 'connecting' }
OPViewModel >> parentContainerModel [

	^ self parentViewModel model
]

{ #category : 'accessing' }
OPViewModel >> parentViewModel [

	^ parentViewModel ifNil: [
		  parentViewModel := self findParentViewModel ]
]

{ #category : 'printing' }
OPViewModel >> printOn: aStream [
	"Append to the argument, aStream, a sequence of characters that
	identifies the receiver."

	super printOn: aStream.
	aStream << '('.
	model printOn: aStream.
	aStream << ')'
]

{ #category : 'accessing' }
OPViewModel >> projectViewModel [
    ^ self parentViewModel ifNotNil: [ :p | p projectViewModel ]
]

{ #category : 'as yet unclassified' }
OPViewModel >> propertyNamed: aSymbol [
	"Read a property value from the underlying domain model."
	^ self model perform: aSymbol asSymbol
]

{ #category : 'accessing' }
OPViewModel >> propertyNamed: aSymbol put: aValue [
	"Mutate the target property. Dispatches form rebuild for structural properties and modelChanged for standard value updates."
	| mutator isStructural |
	aSymbol ifNil: [ ^ self ].
	mutator := (aSymbol endsWith: ':')
		ifTrue: [ aSymbol asSymbol ]
		ifFalse: [ (aSymbol , ':') asSymbol ].
	self model perform: mutator with: aValue.
	isStructural := self structuralPropertySelectors includes: aSymbol asSymbol.
	isStructural
		ifTrue: [ self announcer announce: OPElementFormNeedsRebuild new ]
		ifFalse: [ self modelChanged ]
]

{ #category : 'registering' }
OPViewModel >> registerModelIn: aParentModel [

	(aParentModel respondsTo: #addModel:)
		ifTrue: [ ^ aParentModel addModel: self model ].
	(aParentModel respondsTo: #add:)
		ifTrue: [ ^ aParentModel add: self model ].
	AssertionFailure signal: 'Unsupported parent model: ' , aParentModel printString
]

{ #category : 'accessing' }
OPViewModel >> registry [
    ^ registry
]

{ #category : 'accessing' }
OPViewModel >> registry: aViewModelRegistry [
    registry := aViewModelRegistry
]

{ #category : 'removing' }
OPViewModel >> removeDependentModels [

	self dependentElements asSet do: [ :each |
		(self registry viewModelFor: each) removeModel ]
]

{ #category : 'removing' }
OPViewModel >> removeModel [
	"Template method for removing a model"
	self removeDependentModels.
	self basicRemoveModel.
	self unsubscribeFromModel.
	self unregisterFromRegistry.
	self announceRemoval
]

{ #category : 'initialization' }
OPViewModel >> restoreEndpointsWithSource: aSourceModel target: aTargetModel [
	(aSourceModel isNotNil and: [ aTargetModel isNotNil ]) ifFalse: [ ^ self ].
	self registry ifNotNil: [ :activeRegistry |
		| sourceViewModel targetViewModel |
		sourceViewModel := activeRegistry viewModelFor: aSourceModel.
		targetViewModel := activeRegistry viewModelFor: aTargetModel.
		(sourceViewModel isNotNil and: [ targetViewModel isNotNil ]) ifTrue: [
			self attachModelFrom: sourceViewModel to: targetViewModel.
			^ self ] ].
	(self model respondsTo: #source:) ifTrue: [ self model source: aSourceModel ].
	(self model respondsTo: #target:) ifTrue: [ self model target: aTargetModel ]
]

{ #category : 'accessing' }
OPViewModel >> structuralPropertySelectors [
	"Answer a collection of property selectors whose mutation structurally alters the editor form."
	^ #( )
]

{ #category : 'initialization' }
OPViewModel >> subscribeToModel [
    "Polymorphic hook for subclasses"
]

{ #category : 'private' }
OPViewModel >> unregisterFromRegistry [
	self registry removeViewModelFor: self model
]

{ #category : 'announcements' }
OPViewModel >> unsubscribe: anObject [
	self announcer ifNotNil: [ :ann | ann unsubscribe: anObject ]
]

{ #category : 'private' }
OPViewModel >> unsubscribeFromModel [
	"Hook method for subclasses to detach from domain model events"
]

{ #category : 'validation' }
OPViewModel >> validate [

	"do nothing by default"
]

{ #category : 'accessing' }
OPViewModel >> viewModel [
	^ self
]
