Class {
	#name : 'OPMutationWatchdog',
	#superclass : 'Object',
	#instVars : [
		'metaLink',
		'records',
		'isWatching',
		'instrumentedMethods'
	],
	#classVars : [
		'Default'
	],
	#category : 'OpenPonk-DevTools-Watchdog',
	#package : 'OpenPonk-DevTools',
	#tag : 'Watchdog'
}

{ #category : 'accessing' }
OPMutationWatchdog class >> default [
	^ Default ifNil: [ Default := self new ]
]

{ #category : 'initialization' }
OPMutationWatchdog class >> reset [
<script>
	Default ifNotNil: [ Default stopWatching. Default := nil ]
]

{ #category : 'private' }
OPMutationWatchdog >> buildMetaLink [
	"Build a MetaLink targeting assignment nodes to capture slot writes."
	^ MetaLink new
		metaObject: self;
		selector: #captureWriteOn:node:context:;
		arguments: #( object node context );
		control: #after;
		yourself
]

{ #category : 'capturing' }
OPMutationWatchdog >> captureWriteOn: anObject node: anAssignmentNode context: aContext [
	| slotName |
	isWatching ifFalse: [ ^ self ].

	slotName := anAssignmentNode variable name asSymbol.
	(self shouldIgnoreWriteOn: anObject slot: slotName context: aContext)
		ifTrue: [ ^ self ].

	records add: (self
		newRecordFor: anObject
		slot: slotName
		variable: anAssignmentNode variable
		context: aContext)
]

{ #category : 'capturing' }
OPMutationWatchdog >> captureWriteOn: anObject slot: aSlot newValue: aNewValue context: aContext [
	"Record the slot write if watching is active."
	| slotName oldValue isTransacted isSimulation isInitialization isUiTriggered uiPresenterClassName stackTrace currentContext senderMethod |
	isWatching ifFalse: [ ^ self ].

	slotName := aSlot name.
	oldValue := [ aSlot read: anObject ] on: Error do: [ :error | nil ].
	oldValue = aNewValue ifTrue: [ ^ self ].

	isTransacted := false.
	isSimulation := false.
	isInitialization := false.
	isUiTriggered := false.
	uiPresenterClassName := nil.
	stackTrace := OrderedCollection new.

	currentContext := aContext.
	[ currentContext notNil and: [ stackTrace size < 15 ] ] whileTrue: [
		senderMethod := currentContext method.
		senderMethod ifNotNil: [
			| methodClass selector |
			methodClass := senderMethod methodClass.
			selector := senderMethod selector.
			stackTrace add: (methodClass name , ' >> #' , selector).

			((methodClass includesBehavior: OPCommand) or: [ #( #inTransaction: #execute: ) includes: selector ])
				ifTrue: [ isTransacted := true ].

			((methodClass name includesSubstring: 'Simulator') or: [ selector includesSubstring: 'simulate' ])
				ifTrue: [ isSimulation := true ].

			(#( #initialize #setUp #basicNew ) includes: selector)
				ifTrue: [ isInitialization := true ].

			((methodClass includesBehavior: SpPresenter)
				or: [ (methodClass includesBehavior: OPDiagramController)
				or: [ (methodClass includesBehavior: OPLayouter)
				or: [ methodClass name includesSubstring: 'Editor' ] ] ])
				ifTrue: [
					isUiTriggered := true.
					uiPresenterClassName ifNil: [ uiPresenterClassName := methodClass name ] ] ].
		currentContext := currentContext sender ].

	records add: (OPMutationRecord new
		timestamp: DateAndTime now
		targetClass: anObject class name
		targetIdentity: ([ anObject uuid asString ] on: Error do: [ :error | anObject identityHash asString ])
		slotName: slotName
		oldValue: oldValue
		newValue: aNewValue
		isTransacted: isTransacted
		isSimulation: isSimulation
		isInitialization: isInitialization
		isUiTriggered: isUiTriggered
		uiPresenterClass: uiPresenterClassName
		stackTrace: stackTrace asArray)
]

{ #category : 'monitoring' }
OPMutationWatchdog >> captureWriteOn: aReceiver slotIdentifier: aSlotIdentifier newValue: aNewValue context: aContext [
	"Record the slot write if watching is active."
	| slotName oldVal isTransacted isSim isInit isUi uiClass stackTrace currentCtx senderMethod |
	isWatching ifFalse: [ ^ self ].

	slotName := (aSlotIdentifier respondsTo: #name)
		ifTrue: [ aSlotIdentifier name ]
		ifFalse: [ aSlotIdentifier asSymbol ].

	oldVal := [ (aReceiver class slotNamed: slotName) read: aReceiver ] on: Error do: [ :ex | nil ].
	oldVal = aNewValue ifTrue: [ ^ self ].

	isTransacted := false.
	isSim := false.
	isInit := false.
	isUi := false.
	uiClass := nil.
	stackTrace := OrderedCollection new.

	currentCtx := aContext.
	[ currentCtx notNil and: [ stackTrace size < 15 ] ] whileTrue: [
		senderMethod := currentCtx method.
		senderMethod ifNotNil: [
			| mClass mSel |
			mClass := senderMethod methodClass.
			mSel := senderMethod selector.
			stackTrace add: (mClass name , ' >> #' , mSel).

			((mClass includesBehavior: OPCommand) or: [ #( #inTransaction: #execute: ) includes: mSel ])
				ifTrue: [ isTransacted := true ].

			((mClass name includesSubstring: 'Simulator') or: [ mSel includesSubstring: 'simulate' ])
				ifTrue: [ isSim := true ].

			(#( #initialize #setUp #basicNew ) includes: mSel)
				ifTrue: [ isInit := true ].

			((mClass includesBehavior: SpPresenter)
				or: [ (mClass includesBehavior: OPDiagramController)
				or: [ (mClass includesBehavior: OPLayouter)
				or: [ mClass name includesSubstring: 'Editor' ] ] ])
				ifTrue: [
					isUi := true.
					uiClass ifNil: [ uiClass := mClass name ] ] ].
		currentCtx := currentCtx sender ].

	records add: (OPMutationRecord new
		timestamp: DateAndTime now
		targetClass: aReceiver class name
		targetIdentity: ([ aReceiver uuid asString ] on: Error do: [ :e | aReceiver identityHash asString ])
		slotName: slotName
		oldValue: oldVal
		newValue: aNewValue
		isTransacted: isTransacted
		isSimulation: isSim
		isInitialization: isInit
		isUiTriggered: isUi
		uiPresenterClass: uiClass
		stackTrace: stackTrace asArray)
]

{ #category : 'reporting' }
OPMutationWatchdog >> copyReportToClipboard [
	"Backward compatible alias for exportSuspiciousReport."
	^ self exportSuspiciousReport
]

{ #category : 'reporting' }
OPMutationWatchdog >> exportSuspiciousReport [
	"Copy the structured markdown report of suspicious mutations to the system clipboard and answer it."
	| reportText |
	reportText := self reportForLlm.
	Clipboard clipboardText: reportText.
	^ reportText
]

{ #category : 'capturing' }
OPMutationWatchdog >> extractOldValueFrom: aContext for: aVariableNode [
	aVariableNode isInstanceVariable ifFalse: [ ^ nil ].
	(aContext hasTemporaryVariableNamed: #oldVal) ifFalse: [ ^ nil ].
	^ aContext tempNamed: #oldVal
]

{ #category : 'initialization' }
OPMutationWatchdog >> initialize [

	super initialize.
	records := OrderedCollection new.
	instrumentedMethods := Set new.
	isWatching := false
]

{ #category : 'accessing' }
OPMutationWatchdog >> instrumentedMethods [ ^ instrumentedMethods
]

{ #category : 'testing' }
OPMutationWatchdog >> isExternalTestContext: aContext [
	"Answer whether the execution context belongs to an SUnit test case other than watchdog tests."
	^ (aContext findContextSuchThat: [ :eachContext |
		| receiver |
		receiver := eachContext receiver.
		(receiver class includesBehavior: TestCase)
			and: [ (receiver class includesBehavior: OPMutationWatchdogTest) not ] ]) notNil
]

{ #category : 'testing' }
OPMutationWatchdog >> isInitializationMethod: aCompiledMethod [
	| mClass mSel |
	mClass := aCompiledMethod methodClass.
	mSel := aCompiledMethod selector.
	mSel = #initialize ifTrue: [ ^ true ].
	(mClass name endsWith: 'Examples') ifTrue: [ ^ true ].
	(mClass name endsWith: 'Factory') ifTrue: [ ^ true ].
	(mClass name includesSubstring: 'Materializer') ifTrue: [ ^ true ].
	(mClass name includesSubstring: 'Reader') ifTrue: [ ^ true ].
	(mSel beginsWith: 'example') ifTrue: [ ^ true ].
	^ self isLifecycleOrProjectionSelector: mSel
]

{ #category : 'testing' }
OPMutationWatchdog >> isLifecycleOrProjectionSelector: aSelector [
	"Answer whether aSelector represents visual diagram projection, shape initialization, tool deselect, or project lifecycle."
	^ #(
		#initialize #setUp #basicNew
		#createDiagramElement #renderDiagramElement #renderIn:
		#createOwnedElementsWithoutController #createEndLabels
		#ensureDiagramElement #ensureShownDependenciesInDiagram:
		#showWithoutDependentInDiagram: #showWithoutDependentInDiagramModel:
		#showAllElements #showDiagramElement: #updateAfterDiagramFocused
		#renderSimplified #openProject: #openDiagrams #openExample: #openExampleEmptyModel #emptyModel
		#ensureModelsHaveDiagrams #loadItems #buildDiagram
		#addModel: #addDiagram: #addDiagrams: #moveParticipantsFrom:to: #createDiagram #copyDiagram:named:
		#in:forModelElement: #forModelElement: #renderToPosition:onCanvas:
		#addAttribute: #addOperation: #addLiteral: #updateStereotype
		#updateFromRender #stonPostReferenceResolution #materializeDiagramOf:from:
		#materializeModelFrom: #stonProcessSubObjects:
		#deselect
	) includes: aSelector
]

{ #category : 'testing' }
OPMutationWatchdog >> isSimulationMethod: aCompiledMethod [
	| mClass mSel |
	mClass := aCompiledMethod methodClass.
	mSel := aCompiledMethod selector.
	^ (mClass name includesSubstring: 'Simulator')
		or: [ mSel includesSubstring: 'simulate' ]
]

{ #category : 'testing' }
OPMutationWatchdog >> isTransactedMethod: aCompiledMethod [
	| methodClass selector |
	methodClass := aCompiledMethod methodClass.
	selector := aCompiledMethod selector.
	^ (methodClass includesBehavior: OPCommand)
		or: [ #( #inTransaction: #execute: ) includes: selector ]
]

{ #category : 'testing' }
OPMutationWatchdog >> isTransientSlot: aSlotName onClass: aClass [
	"Answer whether aSlotName represents a non-persisted or non-domain instance variable for aClass."
	| slotSymbol diagramClass invisibleShapeClass |
	slotSymbol := aSlotName asSymbol.
	(#( #announcer #announcers #events #changeSupport #subelements #parent #roassalShape #canvas #eventHandler #cache #cachedBounds #cachedEncompassingRectangle ) includes: slotSymbol)
		ifTrue: [ ^ true ].
	invisibleShapeClass := OPInvisibleOnMouseShape.
	(aClass includesBehavior: invisibleShapeClass) ifTrue: [ ^ true ].
	diagramClass := OPDiagram.
	(aClass includesBehavior: diagramClass) ifTrue: [
		(#( #isOpen #isSelected #camera #bounds ) includes: slotSymbol) ifTrue: [ ^ true ] ].
	(aClass includesBehavior: OPDiagramElement)
		ifTrue: [
			| persistentNames |
			persistentNames := [ (aClass stonAllInstVarNames collect: [ :eachSlot | eachSlot asSymbol ]) asSet ]
				on: Error
				do: [ :error | Set new ].
			persistentNames ifNotEmpty: [ (persistentNames includes: slotSymbol) ifFalse: [ ^ true ] ] ].
	^ false
]

{ #category : 'factory' }
OPMutationWatchdog >> newRecordFor: anObject slot: aSlotName variable: aVariableNode context: aContext [
	| record |
	record := OPMutationRecord new
		timestamp: DateAndTime now;
		targetClass: anObject class name;
		targetIdentity: (self targetIdentityFor: anObject);
		slotName: aSlotName;
		oldValue: (self extractOldValueFrom: aContext for: aVariableNode);
		newValue: (self readSlot: aSlotName from: anObject);
		isUiTriggered: true;
		uiPresenterClass: nil;
		yourself.
	self populateContextInfoFrom: aContext into: record.
	^ record
]

{ #category : 'capturing' }
OPMutationWatchdog >> populateContextInfoFrom: aContext into: aRecord [
	| currentCtx stackTrace isTransacted isSim isInit |
	stackTrace := OrderedCollection new.
	isTransacted := false.
	isSim := false.
	isInit := false.

	currentCtx := aContext.
	[ currentCtx notNil ] whileTrue: [
		currentCtx method ifNotNil: [ :method |
			stackTrace size < 100 ifTrue: [
				stackTrace add: method methodClass name , ' >> #' , method selector ].
			(isTransacted not and: [ self isTransactedMethod: method ]) ifTrue: [ isTransacted := true ].
			(isSim not and: [ self isSimulationMethod: method ]) ifTrue: [ isSim := true ].
			(isInit not and: [ self isInitializationMethod: method ]) ifTrue: [ isInit := true ] ].
		currentCtx := currentCtx sender ].

	aRecord
		stackTrace: stackTrace asArray;
		isTransacted: isTransacted;
		isSimulation: isSim;
		isInitialization: isInit
]

{ #category : 'printing' }
OPMutationWatchdog >> printReportOn: aStream [
	"Format captured suspicious mutations into aStream."
	| suspicious |
	suspicious := self suspiciousRecords.
	aStream << '=== OPMutationWatchdog Report ==='; cr.
	aStream << 'Total records captured: ' << records size asString; cr.
	aStream << 'Suspicious (naked UI) mutations: ' << suspicious size asString; cr; cr.
	suspicious do: [ :rec |
		aStream << rec summaryString; cr.
		aStream << '  Call Stack (top 5):'; cr.
		(rec stackTrace copyFrom: 1 to: (5 min: rec stackTrace size)) do: [ :frame |
			aStream << '    - ' << frame; cr ].
		aStream cr ]
]

{ #category : 'capturing' }
OPMutationWatchdog >> readSlot: aSlotName from: anObject [
	^ [ (anObject class slotNamed: aSlotName) read: anObject ]
		on: Error
		do: [ nil ]
]

{ #category : 'accessing' }
OPMutationWatchdog >> records [ ^ records
]

{ #category : 'printing' }
OPMutationWatchdog >> report [
	"Answer a full report of suspicious mutations as a string."
	^ String streamContents: [ :stream | self printReportOn: stream ]
]

{ #category : 'printing' }
OPMutationWatchdog >> reportForLlm [
	"Answer a structured markdown report of suspicious uncommanded mutations formatted for LLM analysis with up to 100 stack frames."
	| suspicious grouped |
	suspicious := self suspiciousRecords.
	suspicious ifEmpty: [ ^ '# OpenPonk Uncommanded Mutation Report
No suspicious uncommanded mutations recorded.' ].
	grouped := suspicious groupedBy: [ :rec | rec targetClass , ' >> #' , rec slotName asString ].
	^ String streamContents: [ :stream |
		stream nextPutAll: '# OpenPonk Uncommanded Mutation Report'; cr.
		stream nextPutAll: 'Total suspicious mutations: '; nextPutAll: suspicious size asString; cr.
		stream nextPutAll: 'Unique mutation sites: '; nextPutAll: grouped size asString; cr; cr.
		grouped keysAndValuesDo: [ :targetKey :recordsList |
			| sample filtered |
			sample := recordsList first.
			stream nextPutAll: '## '; nextPutAll: targetKey; cr.
			stream nextPutAll: '- Occurrences: '; nextPutAll: recordsList size asString; cr.
			stream nextPutAll: '- Sample value: '; nextPutAll: sample newValue asString; cr.
			stream nextPutAll: '- UI origin: '; nextPutAll: (sample uiPresenterClass ifNil: [ 'none' ]); cr.
			stream nextPutAll: '- Target identity: '; nextPutAll: sample targetIdentity asString; cr.
			stream nextPutAll: '- Stack Trace (full up to 100 frames):'; cr.
			filtered := sample stackTrace reject: [ :frame |
				(frame includesSubstring: 'MetaLink')
					or: [ (frame includesSubstring: 'OPMutationWatchdog')
					or: [ (frame includesSubstring: 'ReflectiveMethod')
					or: [ (frame includesSubstring: 'WorldState')
					or: [ (frame includesSubstring: 'MorphicEvent')
					or: [ frame includesSubstring: 'OSWindow' ] ] ] ] ] ].
			filtered do: [ :frame |
				stream nextPutAll: '    - '; nextPutAll: frame; cr ].
			stream cr ] ]
]

{ #category : 'actions' }
OPMutationWatchdog >> reset [ records := OrderedCollection new
]

{ #category : 'testing' }
OPMutationWatchdog >> shouldIgnoreWriteOn: anObject slot: aSlotName context: aContext [
	(self isTransientSlot: aSlotName onClass: anObject class) ifTrue: [ ^ true ].
	^ self isExternalTestContext: aContext
]

{ #category : 'controlling' }
OPMutationWatchdog >> startWatching [
	"Install metalink on assignment nodes of non-transient slots for each target class."
	| targetClasses |
	self stopWatching.
	self reset.
	metaLink := self buildMetaLink.
	targetClasses := self targetClasses.
	targetClasses do: [ :cls |
		cls methods do: [ :method |
			method ast assignmentNodes do: [ :assignNode |
				(assignNode variable isInstanceVariable and: [
					(self isTransientSlot: assignNode variable name onClass: cls) not ]) ifTrue: [
					assignNode link: metaLink.
					instrumentedMethods add: (cls -> method selector) ] ] ] ].
	isWatching := true
]

{ #category : 'controlling' }
OPMutationWatchdog >> stopWatching [
	"Uninstall metalink and force clean recompilation of all instrumented methods."
	isWatching := false.
	metaLink ifNotNil: [
		metaLink uninstall.
		metaLink := nil ].
	instrumentedMethods do: [ :assoc |
		| cls sel |
		cls := assoc key.
		sel := assoc value.
		(cls includesSelector: sel) ifTrue: [
			(cls >> sel) recompile ] ].
	instrumentedMethods removeAll.
]

{ #category : 'accessing' }
OPMutationWatchdog >> suspiciousRecords [
	"Return all mutations that occurred outside a transaction and are not whitelisted."
	^ records select: [ :each |
		each isTransacted not
			and: [ each isSimulation not
			and: [ each isInitialization not ] ] ]
]

{ #category : 'accessing' }
OPMutationWatchdog >> targetClasses [
	"Answer model and diagram element classes to be monitored, excluding temporary feedback shapes."
	| resultClasses invisibleShapeClass |
	resultClasses := OrderedCollection new.
	(self packageOrganizer packages select: [ :eachPackage | eachPackage name beginsWith: 'OpenPonk' ]) do: [ :eachPackage |
		eachPackage classes do: [ :eachClass |
			((eachClass includesBehavior: OPModelObject)
				or: [ (eachClass includesBehavior: OPDiagramElement)
				or: [ eachClass package name includesSubstring: '-Models' ] ]) ifTrue: [
				resultClasses add: eachClass ] ] ].
	invisibleShapeClass := OPInvisibleOnMouseShape.
	resultClasses removeAllFoundIn: { invisibleShapeClass }.
	^ (resultClasses select: [ :eachClass | eachClass isObsolete not ]) asSet asOrderedCollection
]

{ #category : 'capturing' }
OPMutationWatchdog >> targetIdentityFor: anObject [
	^ [ anObject uuid asString ]
		on: Error
		do: [ anObject identityHash asString ]
]

{ #category : 'private' }
OPMutationWatchdog >> targetSlotsFor: aClass [
	"Answer non-transient, mutable domain slots for the given class."
	^ aClass slots reject: [ :slot | self isTransientSlot: slot name onClass: aClass ]
]
