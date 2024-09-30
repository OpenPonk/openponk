Class {
	#name : 'OPShape',
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
	#category : 'OpenPonk-Core-Shapes',
	#package : 'OpenPonk-Core',
	#tag : 'Shapes'
}

{ #category : 'rendering' }
OPShape class >> forModelElement: anObject [

	^ self new
		  modelElement: anObject;
		  yourself
]

{ #category : 'rendering' }
OPShape class >> in: anOwner [

	^ self new
		  owningElement: anOwner;
		  yourself
]

{ #category : 'rendering' }
OPShape class >> in: anOwner forModelElement: anObject [

	^ self new
		  modelElement: anObject;
		  owningElement: anOwner;
		  yourself
]

{ #category : 'testing' }
OPShape class >> isAbstract [
	^ self = OPShape
]

{ #category : 'rendering' }
OPShape class >> renderForController: aController [

	^ self new
		  modelElement: aController model;
		  renderIn: aController diagramController canvas;
		  yourself
]

{ #category : 'rendering' }
OPShape class >> renderSimplifiedForController: aController [

	^ self new
		  renderBasicShapeIn: aController diagramController canvas;
		  yourself
]

{ #category : 'ston-core' }
OPShape class >> stonAllInstVarNames [

	"Override to encode my instances using a custom set of instance variables or to define their order."

	^ #( #modelElements #owningElement #targetEdges #sourceEdges
	     #sharedStyle #localStyle #ownedElements )
]

{ #category : 'interactions' }
OPShape >> addDraggableInteraction [

	roassalShape @ RSDraggable
]

{ #category : 'interactions' }
OPShape >> addEventForwardingFrom: anOriginalRoassalShape to: aTargetRoassalShape [

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
OPShape >> addEventForwardingToOwner [

	| ownerRoassalShape |
	ownerRoassalShape := self owningElement
		                     ifNil: [ ^ self ]
		                     ifNotNil: [ :owner |
		                     owner roassalShape ifNil: [ ^ self ] ].
	self addEventForwardingFrom: roassalShape to: ownerRoassalShape
]

{ #category : 'interactions' }
OPShape >> addInteractions [

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
OPShape >> addResizableInteraction [

	self resizableInteractionTarget @ OPRSResizable
]

{ #category : 'interactions' }
OPShape >> addSelectableInteraction [

	roassalShape @ self selectableInteraction
]

{ #category : 'interactions' }
OPShape >> addSelectionDraggableInteraction [

	roassalShape @ OPRSSelectionDraggable
]

{ #category : 'as yet unclassified' }
OPShape >> addedByMouseClickTo: aPoint [

	"Do nothing by default. The given point is position where user clicked by mouse in order to create the element. If the shape was not added by a mouse click, this method is not called. May be overriden to translate to that position or react in any other way."

	
]

{ #category : 'as yet unclassified' }
OPShape >> allOwnedShapesPositionableByUser [

	self isRendered ifFalse: [ ^ #(  ) ].
	^ self ownedElements flatCollect: #allOwnedShapesPositionableByUser
]

{ #category : 'as yet unclassified' }
OPShape >> allShapesPositionableByUser [

	^ self topMostOwningElement allOwnedShapesPositionableByUser
]

{ #category : 'accessing' }
OPShape >> canvas [

	^ roassalShape canvas
]

{ #category : 'initialization' }
OPShape >> createOwnedElementsWithoutController [

	"Might be overriden to add owned diagram elements that have no controller that would create them, for example labels. Make sure these do not exist yet (that could produce them multiple times)"

	
]

{ #category : 'instance creation' }
OPShape >> fromSton: stonReader [

	stonReader parseMapDo: [ :instVarName :value |
		instVarName = #modelElements
			ifTrue: [
				self modelElements: (value collect: [ :each |
						 OPModelObjectReference withUUID: ([ UUID fromString: each ]
								  on: Error
								  do: [ each ]) ]) ]
			ifFalse: [ self instVarNamed: instVarName asString put: value ] ]
]

{ #category : 'initialization' }
OPShape >> initialize [

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
OPShape >> isPositionableByUser [

	^ false
]

{ #category : 'testing' }
OPShape >> isRendered [

	^ roassalShape isNotNil and: [ roassalShape isInACanvas ]
]

{ #category : 'testing' }
OPShape >> isRenderedWithOwnedElements [

	^ self isRendered and: [ 
		  self ownedElements allSatisfy: [ :each | 
			  each isRenderedWithOwnedElements ] ]
]

{ #category : 'testing' }
OPShape >> isSelectable [

	^ roassalShape isSelectable
]

{ #category : 'accessing' }
OPShape >> localStyle [
	^ localStyle
]

{ #category : 'accessing' }
OPShape >> localStyle: aStyle [

	localStyle ifNotNil: [ localStyle removedFromStyledElement: self ].
	(localStyle := aStyle) addedAsLocalToStyledElement: self.
	self styleChanged.
]

{ #category : 'accessing' }
OPShape >> model [

	self
		deprecated: 'Use #modelElement instead'
		transformWith: '`@receiver model' -> '`@receiver modelElement'.
	^ self modelElement
]

{ #category : 'initialization' }
OPShape >> modelChanged [

	self isRendered ifTrue: [ self updateRenderFromModel ]
]

{ #category : 'accessing' }
OPShape >> modelElement [

	^ self ownModelElement ifNil: [ self owningElement ifNotNil: #modelElement ]
		  
]

{ #category : 'accessing' }
OPShape >> modelElement: anObject [

	anObject ifNil: [ ^ self modelElements: #(  ) ].
	self modelElements: { anObject }
]

{ #category : 'accessing' }
OPShape >> modelElements [

	^ modelElements
]

{ #category : 'accessing' }
OPShape >> modelElements: aCollection [

	(self owningElement isNotNil and: [ 
		 aCollection includes: self owningElement modelElement ]) ifTrue: [ 
		aCollection size > 1 ifTrue: [ 
			self error: 'Cannot have same modelElement as owningElement has' ].
		^ self modelElement: nil ].

	modelElements := aCollection
]

{ #category : 'testing' }
OPShape >> movesWithOtherShape [

	^ false
]

{ #category : 'accessing' }
OPShape >> ownModelElement [

	^ self modelElements ifEmpty: [ nil ] ifNotEmpty: #first
]

{ #category : 'initialization' }
OPShape >> ownedElement: aShape renderedIn: aCanvas [

	self isRendered ifTrue: [ 
		self
			assert: roassalShape canvas = aCanvas
			description:
			'Reusing same diagram element for 2 canvases not allowed'.
		^ self owningElement ifNotNil: [ :owner | 
			  owner ownedElement: aShape renderedIn: aCanvas ] ].
	self renderIn: aCanvas
]

{ #category : 'accessing' }
OPShape >> ownedElements [
	^ ownedElements
]

{ #category : 'accessing' }
OPShape >> ownedElements: aCollection [

	ownedElements
		removeAll;
		addAll: aCollection
]

{ #category : 'accessing' }
OPShape >> owningElement [
	^ owningElement
]

{ #category : 'accessing' }
OPShape >> owningElement: aDiagramElement [

	(aDiagramElement isNotNil and: [ 
		 self modelElements includes: aDiagramElement modelElement ]) 
		ifTrue: [ 
			self modelElements size > 1 ifTrue: [ 
				self error: 'Cannot have same modelElement as owningElement has' ].
			self modelElement: nil ].
	owningElement := SRToOneLink
		                 on: self
		                 slot: #owningElement
		                 oppositeSlot: #ownedElements
		                 updateFrom: owningElement
		                 to: aDiagramElement
]

{ #category : 'removing' }
OPShape >> remove [

	[ self ownedElements isNotEmpty ] whileTrue: [
		self ownedElements anyOne remove ].
	self removeRender.
	self owningElement: nil
]

{ #category : 'removing' }
OPShape >> removeRender [

	self ownedElements do: #removeRender.
	roassalShape ifNil: [ ^ self ].
	roassalShape remove.
	roassalShape := nil
]

{ #category : 'rendering' }
OPShape >> renderBasicShape [

	"should render a simple shape without using any modelElement info and any advanced shape complexity"

	^ self subclassResponsibility
]

{ #category : 'rendering' }
OPShape >> renderBasicShapeIn: aCanvas [

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
OPShape >> renderIn: aCanvas [

	self isRendered ifTrue: [ ^ self ].
	self renderBasicShapeIn: aCanvas.
	self renderShapeDetails.
	self addInteractions.
	self createOwnedElementsWithoutController.
	self ownedElements do: [ :each | each renderIn: aCanvas ].
	self updateRenderFromModel.
	self updateRenderFromStyles.
	self updateRenderFromSelf.
	self owningElement ifNotNil: [ :element |
		element ownedElement: self renderedIn: self canvas ].
	^ roassalShape
]

{ #category : 'rendering' }
OPShape >> renderShapeDetails [

	"Should render details of a shape created by renderBasicShape. This method is there to add interactivity and complexity like adding labels, actions on click etc. that have no own diagram elements (that labels usually have!)."

	"do nothing by default"

	
]

{ #category : 'interactions' }
OPShape >> resizableInteractionTarget [

	^ roassalShape
]

{ #category : 'serialization' }
OPShape >> resolveAllModelElements: aCollection [

	self resolveModelElements: aCollection.
	self ownedElements do: [ :each | 
		each resolveAllModelElements: aCollection ]
]

{ #category : 'serialization' }
OPShape >> resolveModelElements: aCollection [

	self modelElements: (self modelElements collect: [ :each |
			 each modelObjectFrom: aCollection ])
]

{ #category : 'rendering' }
OPShape >> roassalShape [

	^ roassalShape
]

{ #category : 'interactions' }
OPShape >> selectableInteraction [

	^ OPRSNoInteraction
]

{ #category : 'accessing' }
OPShape >> sharedStyle [
	^ sharedStyle ifNil: [ self owningElement ifNotNil: #sharedStyle ]
]

{ #category : 'accessing' }
OPShape >> sharedStyle: aStyle [

	sharedStyle ifNotNil: [ sharedStyle removedFromStyledElement: self ].
	(sharedStyle := aStyle) addedAsSharedToStyledElement: self.
	self styleChanged.
]

{ #category : 'interactions' }
OPShape >> shouldBePositionableByUser [

	^ false
]

{ #category : 'interactions' }
OPShape >> shouldBeResizableByUser [

	^ false
]

{ #category : 'interactions' }
OPShape >> shouldBeSelectable [

	^ self selectableInteraction ~= OPRSNoInteraction and: [
		  self selectableInteraction class ~= OPRSNoInteraction ]
]

{ #category : 'accessing' }
OPShape >> sourceEdges [
	^ sourceEdges
]

{ #category : 'accessing' }
OPShape >> sourceEdges: aCollection [
	sourceEdges
		removeAll;
		addAll: aCollection
]

{ #category : 'ston persistence' }
OPShape >> stonOn: stonWriter [

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
OPShape >> stonPostReferenceResolution [

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
OPShape >> stonProcessSubObjects: block [

	"Execute block to (potentially) change each of my subObjects.
	In general, all instance and indexable variables are processed.
	Overwrite when necessary. Not used when #stonContainSubObjects returns false."

	self class stonAllInstVarNames do: [ :each | 
		self
			instVarNamed: each
			put: (block value: (self instVarNamed: each)) ]
]

{ #category : 'initialization' }
OPShape >> styleChanged [

	self isRendered ifTrue: [ self updateRenderFromStyles ]
]

{ #category : 'accessing' }
OPShape >> stylePropertyNamed: aName ifAbsent: aBlock [

	| nameSymbol |
	nameSymbol := aName asSymbol.
	self localStyle ifNotNil: [ :style | 
		style at: nameSymbol ifPresent: [ :value | ^ value ] ].
	self sharedStyle ifNotNil: [ :style | 
		style at: nameSymbol ifPresent: [ :value | ^ value ] ].
	self owningElement ifNotNil: [ :owner | 
		^ owner stylePropertyNamed: nameSymbol ifAbsent: aBlock ].
	^ aBlock value
]

{ #category : 'accessing' }
OPShape >> stylePropertyNamed: aName put: aValue [

	self localStyle ifNil: [ self localStyle: OPOpenPonkShapeStyle new ].
	self localStyle at: aName asSymbol put: aValue
]

{ #category : 'initialization' }
OPShape >> supportsColorChange [

	^ (self supportsColorChangeOfType: #fillColor) or: [
		  (self supportsColorChangeOfType: #strokeColor) or: [
			  self supportsColorChangeOfType: #fontColor ] ]
]

{ #category : 'initialization' }
OPShape >> supportsColorChangeOfType: aSymbol [

	^ (self respondsTo: aSymbol asSymbol) and: [
		  self respondsTo: aSymbol asMutator ]
]

{ #category : 'accessing' }
OPShape >> targetEdges [
	^ targetEdges
]

{ #category : 'accessing' }
OPShape >> targetEdges: aCollection [
	targetEdges
		removeAll;
		addAll: aCollection
]

{ #category : 'initialization' }
OPShape >> topMostOwningElement [

	^ self owningElement
		  ifNil: [ self ]
		  ifNotNil: [ :owner | owner topMostOwningElement ]
]

{ #category : 'initialization' }
OPShape >> updateFromRender [

	self ownedElements do: #updateFromRender
]

{ #category : 'rendering' }
OPShape >> updateRenderFromModel [

	self ownedElements select: #isRendered thenDo: #updateRenderFromModel
]

{ #category : 'rendering' }
OPShape >> updateRenderFromSelf [

	self isRendered ifFalse: [ ^ self ].
	self ownedElements do: #updateRenderFromSelf.
	roassalShape signalUpdate
]

{ #category : 'initialization' }
OPShape >> updateRenderFromStyles [

	"do nothing by default"

	
]
