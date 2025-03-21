"
A DCController is the parent class to all controller classes.
"
Class {
	#name : 'OPController',
	#superclass : 'Object',
	#instVars : [
		'diagramController',
		'diagramElement',
		'adapter'
	],
	#category : 'OpenPonk-Core-Controllers',
	#package : 'OpenPonk-Core',
	#tag : 'Controllers'
}

{ #category : 'accessing' }
OPController class >> modelClass [
	^ self new modelClass
]

{ #category : 'connecting' }
OPController >> addAsSourceFor: aController [
	(self canBeSourceFor: aController)
		ifFalse: [ self
				error:
					self class asString , ' cannot be source for '
						, aController class asString ].
	aController source: self
]

{ #category : 'connecting' }
OPController >> addAsTargetFor: aController [

	(self canBeTargetFor: aController) ifFalse: [
		self error: self class asString , ' cannot be target for '
			, aController class asString ].
	aController target: self.
	aController
		createModelIn: (self parentWhenTargetFor: aController)
		andShowInDiagram: self diagramController
]

{ #category : 'forms' }
OPController >> buildEditorForm: aForm [
	aForm fromMagritteDescriptions: self magritteDescription
]

{ #category : 'connecting' }
OPController >> canBeSourceFor: aController [
	^ false
]

{ #category : 'connecting' }
OPController >> canBeTargetFor: aController [
	^ false
]

{ #category : 'accessing' }
OPController >> commonModelClassPrefix [
	^ 'OP'
]

{ #category : 'accessing' }
OPController >> dependentControllers [
	^ self dependentElements
		collect:
			[ :each | self diagramController controllerForModel: each ifNone: [ nil ] ]
		thenSelect: #isNotNil
]

{ #category : 'accessing' }
OPController >> dependentElements [
	"model elements that require this one to be rendered in order to render itself"

	^ self elementsToShowInside
]

{ #category : 'forms' }
OPController >> descriptionName [

	<magritteDescription>
	| accessor |
	accessor := MAPluggableAccessor
		            read: [ :me | me model name ]
		            write: [ :me :newValue | 
			            me model name: newValue.
			            self modelChanged ].
	^ MAStringDescription new
		  accessor: accessor;
		  label: 'Name';
		  priority: 1;
		  yourself
]

{ #category : 'accessing' }
OPController >> diagram [

	^ self diagramController diagram
]

{ #category : 'accessing' }
OPController >> diagramController [
	^ diagramController
]

{ #category : 'accessing' }
OPController >> diagramController: aDiagramController [
	diagramController := aDiagramController
]

{ #category : 'accessing' }
OPController >> diagramElement [

	^ diagramElement ifNil: [ OPNoShape instance ]
]

{ #category : 'accessing' }
OPController >> diagramElement: aDiagramElement [

	^ diagramElement := aDiagramElement
]

{ #category : 'accessing' }
OPController >> elementsToShowInside [
	"model elements that should be shown (rendered) automatically when this one is rendered"

	^ #(  )
]

{ #category : 'ui interaction' }
OPController >> ensureDeselected [

	self subclassResponsibility
]

{ #category : 'accessing' }
OPController >> ensureDiagramElement [

	self assert: self diagramElement exists.
	self linkDiagramElementToModel.
	^ self diagramElement
]

{ #category : 'canvas actions' }
OPController >> hideSelectionFeedback [

	self deprecated: 'This should be done by shapes (diagram elements)'
]

{ #category : 'announcements' }
OPController >> internalSubscribeTo: aModel [

	aModel announcer weak
		when: OPElementRenamed
		send: #modelChanged
		to: self
]

{ #category : 'announcements' }
OPController >> internalUnsubscribeFrom: aModel [

	"aModel unsubscribe: self"
]

{ #category : 'testing' }
OPController >> isHideable [

	^ false
]

{ #category : 'testing' }
OPController >> isRendered [

	^ self diagramElement isRendered
]

{ #category : 'testing' }
OPController >> isTargetUsedAsContainer [

	^ true
]

{ #category : 'construction' }
OPController >> linkDiagramElementToModel [

	self diagramElement modelElement: self model
]

{ #category : 'accessing' }
OPController >> model [

	^ adapter ifNotNil: [ :existingAdapter | existingAdapter model ]
]

{ #category : 'accessing' }
OPController >> model: aModel [

	aModel ifNotNil: [ 
		aModel uuid ifNil: [ 
			self error: 'All model objects must have a uuid to be used by OP' ] ].
	self model ifNotNil: [ :m | self internalUnsubscribeFrom: m ].
	adapter := OPModelAdapter forModel: aModel.
	self model ifNotNil: [ :m | self internalSubscribeTo: m ]
]

{ #category : 'announcements' }
OPController >> modelChanged [

	self diagramElement modelChanged
]

{ #category : 'accessing' }
OPController >> modelClass [
	^ self subclassResponsibility
]

{ #category : 'accessing' }
OPController >> nameOfType [
	^ (self diagramController typeOfModel: self model) name
]

{ #category : 'connecting' }
OPController >> parentContainerModel [
	"Redefine to answer model that acts as a primary container of my model and other elements on my model's level. If I am always directly inside diagramController without any intermediate structure, this may answer self diagramController model"

	^ self subclassResponsibility
]

{ #category : 'connecting' }
OPController >> parentWhenTargetFor: aCreatedController [

	^ aCreatedController isTargetUsedAsContainer
		  ifTrue: [ self model ]
		  ifFalse: [ self parentContainerModel ]
]

{ #category : 'figures' }
OPController >> refreshFigure [

	self
		deprecated: 'Use #modelChanged instead'
		transformWith: '`@receiver refreshFigure'
			-> '`@receiver modelChanged'.

	^ self modelChanged
]

{ #category : 'deprecated' }
OPController >> remove [

	self deprecated: 'Use removeControllerAndDiagramElement instead.'.
	self removeControllerAndDiagramElement
]

{ #category : 'destruction' }
OPController >> removeController [

	self model ifNotNil: [ :m |
		self
			removeDependentControllers;
			internalUnsubscribeFrom: m ].
	self removeRender.
	self removeFromDiagramController
]

{ #category : 'destruction' }
OPController >> removeControllerAndDiagramElement [

	self model ifNotNil: [ :m |
		self
			removeDependentControllersAndDiagramElements;
			internalUnsubscribeFrom: m ].
	self removeFromDiagramController.
	self removeDiagramElement
]

{ #category : 'destruction' }
OPController >> removeControllerAndModel [

	self removeDependentConrollersAndModels.
	self removeControllerAndDiagramElement.
	self removeModel.
	self model: nil
]

{ #category : 'destruction' }
OPController >> removeDependentConrollersAndModels [

	self dependentControllers do: [ :each |
		self diagramController
			controllerForModel: each model
			ifFound: [ :found | found removeControllerAndModel ] ]
]

{ #category : 'destruction' }
OPController >> removeDependentControllers [

	self dependentControllers do: [ :each |
		self diagramController controllers
			detect: [ :ctrl | ctrl model = each model ]
			ifFound: #removeController ]
]

{ #category : 'destruction' }
OPController >> removeDependentControllersAndDiagramElements [
	self dependentControllers
		do: [ :each | 
			self diagramController controllers
				detect: [ :ctrl | ctrl model = each model ]
				ifFound: #removeControllerAndDiagramElement ]
]

{ #category : 'destruction' }
OPController >> removeDiagramElement [

	self diagramElement remove.
	self diagramElement: nil
]

{ #category : 'destruction' }
OPController >> removeFromDiagramController [

	self diagramController ifNil: [ ^ self ].
	self ensureDeselected.
	self diagramController removeController: self
]

{ #category : 'destruction' }
OPController >> removeModel [

	self diagramController elementRemoved.
	self model: nil
]

{ #category : 'destruction' }
OPController >> removeRender [

	self ensureDeselected.
	self diagramElement removeRender
]

{ #category : 'figures' }
OPController >> roassalShape [

	^ self diagramElement roassalShape
]

{ #category : 'canvas actions' }
OPController >> showAcceptFeedbackFor: aController [
	"Return something that understands #remove, or nil to not show any feedback."

	^ OPRSAcceptDenyFeedbackBuilder acceptFeedbackFor: self roassalShape
]

{ #category : 'canvas actions' }
OPController >> showDenyFeedbackFor: aController [
	"Return something that understands #remove, or nil to not show any feedback."

	^ OPRSAcceptDenyFeedbackBuilder denyFeedbackFor: self roassalShape
]

{ #category : 'construction' }
OPController >> showInDiagram: aDiagramController [

	self showWithoutDependentInDiagram: aDiagramController.
	^ self dependentElements do: [ :each |
		  aDiagramController showInDiagramModel: each ]
]

{ #category : 'canvas actions' }
OPController >> showSelectionFeedback [

	self deprecated: 'This should be done by shapes (diagram elements)'
]

{ #category : 'construction' }
OPController >> showWithoutDependentInDiagram: aDiagramController [

	self subclassResponsibility
]

{ #category : 'event handling' }
OPController >> updateAfterDiagramFocused [

	self subclassResponsibility
]

{ #category : 'validation' }
OPController >> validate [

	"do nothing by default"
]
