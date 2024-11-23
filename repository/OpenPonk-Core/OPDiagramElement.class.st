Class {
	#name : 'OPDiagramElement',
	#superclass : 'Object',
	#instVars : [
		'modelElements',
		'owningElement',
		'targetEdges',
		'sourceEdges',
		'sharedStyle',
		'localStyle',
		'ownedElements',
		'roassalShape'
	],
	#category : 'OpenPonk-Core-DiagramElements',
	#package : 'OpenPonk-Core',
	#tag : 'DiagramElements'
}

{ #category : 'rendering' }
OPDiagramElement class >> forModelElement: anObject [

	^ self new
		  modelElement: anObject;
		  yourself
]

{ #category : 'rendering' }
OPDiagramElement class >> in: anOwner [

	^ self new
		  owningElement: anOwner;
		  yourself
]

{ #category : 'rendering' }
OPDiagramElement class >> in: anOwner forModelElement: anObject [

	^ self new
		  modelElement: anObject;
		  owningElement: anOwner;
		  yourself
]

{ #category : 'testing' }
OPDiagramElement class >> isAbstract [
	^ self = OPDiagramElement
]

{ #category : 'rendering' }
OPDiagramElement class >> renderForController: aController [

	^ self new
		  modelElement: aController model;
		  renderIn: aController diagramController canvas;
		  yourself
]

{ #category : 'rendering' }
OPDiagramElement class >> renderSimplifiedForController: aController [

	^ self new
		  renderBasicShapeIn: aController diagramController canvas;
		  yourself
]

{ #category : 'ston-core' }
OPDiagramElement class >> stonAllInstVarNames [

	"Override to encode my instances using a custom set of instance variables or to define their order."

	^ #( #modelElements #owningElement #targetEdges #sourceEdges
	     #sharedStyle #localStyle #ownedElements )
]

{ #category : 'interactions' }
OPDiagramElement >> addDraggableInteraction [

	roassalShape @ RSDraggable
]

{ #category : 'interactions' }
OPDiagramElement >> addEventForwardingFrom: anOriginalRoassalShape to: aTargetRoassalShape [

	| forward |
	forward := [ :event | aTargetRoassalShape announce: event ].
	anOriginalRoassalShape
		when: RSMouseEnter do: forward for: self;
		when: RSMouseLeave do: forward for: self;
		when: RSMouseClick do: forward for: self;
		when: RSMouseDragStart do: forward for: self;
		when: RSMouseDragEnd do: forward for: self;
		when: RSMouseDragging do: forward for: self
]

{ #category : 'interactions' }
OPDiagramElement >> addEventForwardingToOwner [

	| ownerRoassalShape |
	ownerRoassalShape := self owningElement
		                     ifExists: [ :owner |
		                     owner roassalShape ifNil: [ ^ self ] ]
		                     else: [ ^ self ].
	self addEventForwardingFrom: roassalShape to: ownerRoassalShape
]

{ #category : 'interactions' }
OPDiagramElement >> addInteractions [

	self shouldBeResizableByUser ifTrue: [ self addResizableInteraction ].

	self shouldBeSelectable ifTrue: [
		self addSelectableInteraction.
		self shouldBePositionableByUser ifTrue: [
			self addSelectionDraggableInteraction ].
		^ self ].

	self shouldBePositionableByUser ifTrue: [
		self addDraggableInteraction.
		^ self ].

	self addEventForwardingToOwner
]

{ #category : 'interactions' }
OPDiagramElement >> addResizableInteraction [

	self resizableInteractionTarget @ OPRSResizable
]

{ #category : 'interactions' }
OPDiagramElement >> addSelectableInteraction [

	roassalShape @ self selectableInteraction
]

{ #category : 'interactions' }
OPDiagramElement >> addSelectionDraggableInteraction [

	roassalShape @ OPRSSelectionDraggable
]

{ #category : 'rendering' }
OPDiagramElement >> addedByMouseClickTo: aPoint [

	"Do nothing by default. The given point is position where user clicked by mouse in order to create the element. If the shape was not added by a mouse click, this method is not called. May be overriden to translate to that position or react in any other way."

	
]

{ #category : 'enumerating' }
OPDiagramElement >> allOwnedElements [

	^ self ownedElements
	  ,
	  (self ownedElements flatCollect: [ :each | each allOwnedElements ])
]

{ #category : 'enumerating' }
OPDiagramElement >> allOwnedShapesPositionableByUser [

	self isRendered ifFalse: [ ^ #(  ) ].
	^ self ownedElements flatCollect: #allOwnedShapesPositionableByUser
]

{ #category : 'enumerating' }
OPDiagramElement >> allShapesPositionableByUser [

	^ self topMostOwningElement allOwnedShapesPositionableByUser
]

{ #category : 'accessing' }
OPDiagramElement >> attachedShapes [

	^ #(  )
]

{ #category : 'actions' }
OPDiagramElement >> attachedShapesDo: aBlock [

	^ self attachedShapes
		  select: [ :each | each isNotNil and: [ each isInACanvas ] ]
		  thenDo: aBlock
]

{ #category : 'accessing' }
OPDiagramElement >> canvas [

	^ roassalShape canvas
]

{ #category : 'initialization' }
OPDiagramElement >> createOwnedElementsWithoutController [

	"Might be overriden to add owned diagram elements that have no controller that would create them, for example labels. Make sure these do not exist yet (that could produce them multiple times)"

	
]

{ #category : 'accessing' }
OPDiagramElement >> diagramElementOfType: aType withModelElement: anElement ifFound: aFoundBlock [

	((self isKindOf: aType) and: [ modelElements includes: anElement ])
		ifTrue: [ ^ aFoundBlock cull: self ].
	ownedElements do: [ :each |
		each
			diagramElementOfType: aType
			withModelElement: anElement
			ifFound: [ :found | ^ aFoundBlock cull: found ] ]
]

{ #category : 'testing' }
OPDiagramElement >> exists [

	^ true
]

{ #category : 'instance creation' }
OPDiagramElement >> fromSton: stonReader [

	stonReader parseMapDo: [ :instVarName :value |
		instVarName = #modelElements
			ifTrue: [
				self modelElements: (value collect: [ :each |
						 OPModelObjectReference withUUID: ([ UUID fromString: each ]
								  on: Error
								  do: [ each ]) ]) ]
			ifFalse: [ self instVarNamed: instVarName asString put: value ] ]
]

{ #category : 'conditions' }
OPDiagramElement >> ifExists: aFullBlockClosure [

	^ aFullBlockClosure cull: self
]

{ #category : 'existence' }
OPDiagramElement >> ifExists: aFullBlockClosure else: aFullBlockClosure2 [

	^ aFullBlockClosure cull: self
]

{ #category : 'conditions' }
OPDiagramElement >> ifNotExists: aFullBlockClosure [

	^ self
]

{ #category : 'initialization' }
OPDiagramElement >> initialize [

	super initialize.
	modelElements := #(  ).
	ownedElements := SRToManyLink
		                 on: self
		                 slot: #ownedElements
		                 oppositeSlot: #owningElement.
	sourceEdges := SRToManyLink
		               on: self
		               slot: #sourceEdges
		               oppositeSlot: #source.
	targetEdges := SRToManyLink
		               on: self
		               slot: #targetEdges
		               oppositeSlot: #target
]

{ #category : 'testing' }
OPDiagramElement >> isPositionableByUser [

	^ false
]

{ #category : 'testing' }
OPDiagramElement >> isRendered [

	^ roassalShape isNotNil and: [ roassalShape isInACanvas ]
]

{ #category : 'conditions' }
OPDiagramElement >> isRenderedWithOwnedElements [

	^ self isRendered and: [ 
		  self ownedElements allSatisfy: [ :each | 
			  each isRenderedWithOwnedElements ] ]
]

{ #category : 'testing' }
OPDiagramElement >> isSelectable [

	^ roassalShape isSelectable
]

{ #category : 'accessing' }
OPDiagramElement >> localStyle [
	^ localStyle
]

{ #category : 'accessing' }
OPDiagramElement >> localStyle: aStyle [

	localStyle ifNotNil: [ localStyle removedFromStyledElement: self ].
	(localStyle := aStyle) addedAsLocalToStyledElement: self.
	self styleChanged.
]

{ #category : 'accessing' }
OPDiagramElement >> model [

	self
		deprecated: 'Use #modelElement instead'
		transformWith: '`@receiver model' -> '`@receiver modelElement'.
	^ self modelElement
]

{ #category : 'initialization' }
OPDiagramElement >> modelChanged [

	self isRendered ifTrue: [ self updateRenderFromModel ]
]

{ #category : 'accessing' }
OPDiagramElement >> modelElement [

	^ self ownModelElement ifNil: [ self owningElement ifExists: #modelElement ]
		  
]

{ #category : 'accessing' }
OPDiagramElement >> modelElement: anObject [

	anObject ifNil: [ ^ self modelElements: #(  ) ].
	(self modelElements size = 1 and: [
		 self modelElements first == anObject ]) ifTrue: [ ^ self ].
	self modelElements: { anObject }
]

{ #category : 'accessing' }
OPDiagramElement >> modelElements [

	^ modelElements
]

{ #category : 'accessing' }
OPDiagramElement >> modelElements: aCollection [

	self owningElement ifExists: [
		(aCollection includes: self owningElement modelElement) ifTrue: [
			aCollection size > 1 ifTrue: [
				self error: 'Cannot have same modelElement as owningElement has' ].
			^ self modelElement: nil ] ].

	modelElements := aCollection
]

{ #category : 'testing' }
OPDiagramElement >> movesWithOtherShape [

	^ false
]

{ #category : 'accessing' }
OPDiagramElement >> ownModelElement [

	^ self modelElements ifEmpty: [ nil ] ifNotEmpty: #first
]

{ #category : 'initialization' }
OPDiagramElement >> ownedElement: aShape renderedIn: aCanvas [

	self recursivelyOwnedElement: aShape renderedIn: aCanvas
]

{ #category : 'initialization' }
OPDiagramElement >> ownedElement: aShape willRenderIn: aCanvas [

	self isRendered ifTrue: [
		^ self
			  assert: roassalShape canvas = aCanvas
			  description:
			  'Reusing same diagram element for 2 canvases not allowed' ].
	self renderIn: aCanvas
]

{ #category : 'accessing' }
OPDiagramElement >> ownedElements [

	^ ownedElements
]

{ #category : 'accessing' }
OPDiagramElement >> ownedElements: aCollection [

	ownedElements
		removeAll;
		addAll: aCollection
]

{ #category : 'accessing' }
OPDiagramElement >> owningElement [

	^ owningElement ifNil: [ OPNoShape instance ]
]

{ #category : 'accessing' }
OPDiagramElement >> owningElement: aDiagramElement [

	aDiagramElement ifNotNil: [
		(self modelElements includes: aDiagramElement modelElement) ifTrue: [
			self modelElements size > 1 ifTrue: [
				self error: 'Cannot have same modelElement as owningElement has' ].
			self modelElement: nil ] ].
	owningElement := SRToOneLink
		                 on: self
		                 slot: #owningElement
		                 oppositeSlot: #ownedElements
		                 updateFrom: owningElement
		                 to: aDiagramElement
]

{ #category : 'actions' }
OPDiagramElement >> pushBack [

	roassalShape ifNil: [ ^ self ].
	self attachedShapesDo: [ :each | each pushBack ].
	roassalShape pushBack
]

{ #category : 'actions' }
OPDiagramElement >> pushFront [

	roassalShape ifNil: [ ^ self ].
	roassalShape pushFront.
	self attachedShapesDo: [ :each | each pushFront ]
]

{ #category : 'initialization' }
OPDiagramElement >> recursivelyOwnedElement: aShape renderedIn: aCanvas [

	self owningElement recursivelyOwnedElement: aShape renderedIn: aCanvas
]

{ #category : 'removing' }
OPDiagramElement >> remove [

	[ self ownedElements isNotEmpty ] whileTrue: [
		self ownedElements anyOne remove ].
	self removeRender.
	self owningElement: nil
]

{ #category : 'accessing' }
OPDiagramElement >> removeLocalStylePropertyNamed: aName [

	self localStyle ifNotNil: [ :style |
		style removeKeyIfPresent: aName asSymbol ]
]

{ #category : 'removing' }
OPDiagramElement >> removeRender [

	self ownedElements do: [ :each | each removeRender ].
	self attachedShapesDo: [ :each | each remove ].
	roassalShape ifNil: [ ^ self ].
	roassalShape remove.
	roassalShape := nil
]

{ #category : 'rendering' }
OPDiagramElement >> renderBasicShape [

	"should render a simple shape without using any modelElement info and any advanced shape complexity"

	^ self subclassResponsibility
]

{ #category : 'rendering' }
OPDiagramElement >> renderBasicShapeIn: aCanvas [

	self isRendered ifTrue: [ 
		roassalShape canvas = aCanvas ifFalse: [ 
			self error:
				'Reusing same diagram element for 2 canvases not allowed' ].
		^ self ].
	roassalShape := self renderBasicShape.
	roassalShape model: self.
	aCanvas add: roassalShape.
	^ roassalShape
]

{ #category : 'rendering' }
OPDiagramElement >> renderIn: aCanvas [

	self isRendered ifTrue: [ ^ self ].
	self owningElement ownedElement: self willRenderIn: aCanvas.
	self renderBasicShapeIn: aCanvas.
	self renderShapeDetails.
	self addInteractions.
	self createOwnedElementsWithoutController.
	self ownedElements do: [ :each | each renderIn: aCanvas ].
	self updateRenderFromModel.
	self updateRenderFromStyles.
	self updateRenderFromSelf.
	self owningElement ownedElement: self renderedIn: aCanvas.
	^ roassalShape
]

{ #category : 'rendering' }
OPDiagramElement >> renderShapeDetails [

	"Should render details of a shape created by renderBasicShape. This method is there to add interactivity and complexity like adding labels, actions on click etc. that have no own diagram elements (that labels usually have!)."

	"do nothing by default"

	
]

{ #category : 'interactions' }
OPDiagramElement >> resizableInteractionTarget [

	^ roassalShape
]

{ #category : 'serialization' }
OPDiagramElement >> resolveAllModelElements: aCollection [

	| success |
	success := self resolveModelElements: aCollection.
	self ownedElements: (self ownedElements select: [ :each |
			 each resolveAllModelElements: aCollection ]).
	^ success
]

{ #category : 'serialization' }
OPDiagramElement >> resolveModelElements: aCollection [

	self modelElements: (self modelElements collect: [ :each |
			 [ each modelObjectFrom: aCollection ]
				 on: NotFound
				 do: [ :e |
					 OPDiagramInvalid signal:
						 'Diagram references non-existent model element. Try using Proceed to remove it'.
					 ^ false ] ]).
	^ true
]

{ #category : 'rendering' }
OPDiagramElement >> roassalShape [

	^ roassalShape
]

{ #category : 'rendering' }
OPDiagramElement >> roassalShapeUnsubscribe: aSubscriber [

	roassalShape ifNil: [ ^ self ].
	roassalShape announcer unsubscribe: aSubscriber
]

{ #category : 'interactions' }
OPDiagramElement >> selectableInteraction [

	^ OPRSNoInteraction
]

{ #category : 'accessing' }
OPDiagramElement >> sharedStyle [
	^ sharedStyle ifNil: [ self owningElement ifExists: #sharedStyle ]
]

{ #category : 'accessing' }
OPDiagramElement >> sharedStyle: aStyle [

	sharedStyle ifNotNil: [ sharedStyle removedFromStyledElement: self ].
	(sharedStyle := aStyle) addedAsSharedToStyledElement: self.
	self styleChanged.
]

{ #category : 'interactions' }
OPDiagramElement >> shouldBePositionableByUser [

	^ false
]

{ #category : 'interactions' }
OPDiagramElement >> shouldBeResizableByUser [

	^ false
]

{ #category : 'interactions' }
OPDiagramElement >> shouldBeSelectable [

	^ self selectableInteraction ~= OPRSNoInteraction and: [
		  self selectableInteraction class ~= OPRSNoInteraction ]
]

{ #category : 'accessing' }
OPDiagramElement >> sourceEdges [
	^ sourceEdges
]

{ #category : 'accessing' }
OPDiagramElement >> sourceEdges: aCollection [
	sourceEdges
		removeAll;
		addAll: aCollection
]

{ #category : 'ston persistence' }
OPDiagramElement >> stonOn: stonWriter [

	stonWriter writeObject: self streamMap: [ :dictionary | 
		self class stonAllInstVarNames do: [ :each | 
			| value |
			value := self instVarNamed: each.
			each = #modelElements ifTrue: [ 
				value := modelElements collect: [ :eachModelElement | 
					         eachModelElement uuid asString ] ].
			(value isKindOf: SRToManyLink) ifTrue: [ 
				value := Array withAll: value ].
			value ifNotNil: [ dictionary at: each asSymbol put: value ] ] ]
]

{ #category : 'initialization' }
OPDiagramElement >> stonPostReferenceResolution [

	"Hook that is called when references were resolved processing this object or one of its sub objects. This will most probably influence hash values. Override to take appropriate action."

	ownedElements := (SRToManyLink
		                  on: self
		                  slot: #ownedElements
		                  oppositeSlot: #owningElement)
		                 addAll: ownedElements;
		                 yourself.
	sourceEdges := (SRToManyLink
		                on: self
		                slot: #sourceEdges
		                oppositeSlot: #source)
		               addAll: sourceEdges;
		               yourself.
	targetEdges := (SRToManyLink
		                on: self
		                slot: #targetEdges
		                oppositeSlot: #target)
		               addAll: targetEdges;
		               yourself
]

{ #category : 'instance creation' }
OPDiagramElement >> stonProcessSubObjects: block [

	"Execute block to (potentially) change each of my subObjects.
	In general, all instance and indexable variables are processed.
	Overwrite when necessary. Not used when #stonContainSubObjects returns false."

	self class stonAllInstVarNames do: [ :each | 
		self
			instVarNamed: each
			put: (block value: (self instVarNamed: each)) ]
]

{ #category : 'initialization' }
OPDiagramElement >> styleChanged [

	self isRendered ifTrue: [ self updateRenderFromStyles ]
]

{ #category : 'accessing' }
OPDiagramElement >> stylePropertyNamed: aName ifAbsent: aBlock [

	| nameSymbol |
	nameSymbol := aName asSymbol.
	self localStyle ifNotNil: [ :style |
		style at: nameSymbol ifPresent: [ :value | ^ value ] ].
	self sharedStyle ifNotNil: [ :style |
		style at: nameSymbol ifPresent: [ :value | ^ value ] ].
	self owningElement ifExists: [ :owner |
		^ owner stylePropertyNamed: nameSymbol ifAbsent: aBlock ].
	^ aBlock value
]

{ #category : 'accessing' }
OPDiagramElement >> stylePropertyNamed: aName put: aValue [

	self localStyle ifNil: [ self localStyle: OPOpenPonkShapeStyle new ].
	self localStyle at: aName asSymbol put: aValue
]

{ #category : 'initialization' }
OPDiagramElement >> supportsColorChange [

	^ (self supportsColorChangeOfType: #fillColor) or: [
		  (self supportsColorChangeOfType: #strokeColor) or: [
			  self supportsColorChangeOfType: #fontColor ] ]
]

{ #category : 'initialization' }
OPDiagramElement >> supportsColorChangeOfType: aSymbol [

	^ (self respondsTo: aSymbol asSymbol) and: [
		  self respondsTo: aSymbol asMutator ]
]

{ #category : 'accessing' }
OPDiagramElement >> targetEdges [
	^ targetEdges
]

{ #category : 'accessing' }
OPDiagramElement >> targetEdges: aCollection [
	targetEdges
		removeAll;
		addAll: aCollection
]

{ #category : 'initialization' }
OPDiagramElement >> topMostOwningElement [

	^ self owningElement
		  ifExists: [ :owner | owner topMostOwningElement ]
		  else: [ self ]
]

{ #category : 'initialization' }
OPDiagramElement >> updateFromRender [

	self ownedElements do: #updateFromRender
]

{ #category : 'rendering' }
OPDiagramElement >> updateRenderFromModel [

	self ownedElements select: #isRendered thenDo: #updateRenderFromModel
]

{ #category : 'rendering' }
OPDiagramElement >> updateRenderFromSelf [

	self isRendered ifFalse: [ ^ self ].
	self ownedElements do: #updateRenderFromSelf.
	roassalShape signalUpdate
]

{ #category : 'initialization' }
OPDiagramElement >> updateRenderFromStyles [

	self ownedElements select: #isRendered thenDo: #updateRenderFromStyles
]
