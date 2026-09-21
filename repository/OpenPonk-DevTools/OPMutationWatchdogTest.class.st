Class {
	#name : 'OPMutationWatchdogTest',
	#superclass : 'TestCase',
	#instVars : [
		'watchdog',
		'testEntity'
	],
	#category : 'OpenPonk-DevTools-Watchdog',
	#package : 'OpenPonk-DevTools',
	#tag : 'Watchdog'
}

{ #category : 'running' }
OPMutationWatchdogTest >> setUp [
	super setUp.
	watchdog := OPMutationWatchdog new.
	testEntity := OPErdEntity new
]

{ #category : 'running' }
OPMutationWatchdogTest >> tearDown [
	watchdog ifNotNil: [
		watchdog stopWatching.
		watchdog := nil ].
	testEntity := nil.
	super tearDown
]

{ #category : 'tests' }
OPMutationWatchdogTest >> testDiagramWorkspaceSlotsAreTransient [
	"Verify that workspace navigation and layout state slots on OPDiagram are marked as transient."
	| diagramClass |
	diagramClass := OPOpenPonkDiagram.
	self assert: (watchdog isTransientSlot: #isOpen onClass: diagramClass).
	self assert: (watchdog isTransientSlot: #isSelected onClass: diagramClass).
	self assert: (watchdog isTransientSlot: #camera onClass: diagramClass).
	self assert: (watchdog isTransientSlot: #bounds onClass: diagramClass).
	self deny: (watchdog isTransientSlot: #bounds onClass: OPBoundNode)
]

{ #category : 'tests' }
OPMutationWatchdogTest >> testExportSuspiciousReportCopiesToClipboard [
	"Verify that exportSuspiciousReport places formatted markdown into Clipboard and returns the text."
	| record report |
	record := OPMutationRecord new
		timestamp: DateAndTime now
		targetClass: 'OPErdEntity'
		targetIdentity: '123'
		slotName: #isWeak
		oldValue: false
		newValue: true
		isTransacted: false
		isSimulation: false
		isInitialization: false
		isUiTriggered: true
		uiPresenterClass: 'OPErdEntityEditor'
		stackTrace: #( 'OPErdEntityEditor >> #save' ).
	watchdog records add: record.
	report := watchdog exportSuspiciousReport.
	self assert: (report includesSubstring: 'OPErdEntity >> #isWeak').
	self assert: Clipboard clipboardText equals: report
]

{ #category : 'tests' }
OPMutationWatchdogTest >> testExternalTestCaseMutationsAreIgnored [
	"Verify that slot writes occurring during execution of an external TestCase are ignored."
	| recordsCountBefore |
	watchdog startWatching.
	recordsCountBefore := watchdog records size.
	OPDiagramControllerTest run: #testShowModelInDiagram.
	watchdog stopWatching.
	self assert: watchdog records size equals: recordsCountBefore
]

{ #category : 'tests' }
OPMutationWatchdogTest >> testInvisibleOnMouseShapeSlotsAreTransient [
	"Verify that temporary edge routing feedback shapes are ignored by the watchdog."
	| invisibleShapeClass |
	invisibleShapeClass := OPInvisibleOnMouseShape.
	self assert: (watchdog isTransientSlot: #bounds onClass: invisibleShapeClass).
	self assert: (watchdog isTransientSlot: #owningElement onClass: invisibleShapeClass)
]

{ #category : 'tests' }
OPMutationWatchdogTest >> testIsExternalTestContext [
	"Verify that thisContext inside OPMutationWatchdogTest is recognized as NOT external."
	self deny: (watchdog isExternalTestContext: thisContext)
]

{ #category : 'tests' }
OPMutationWatchdogTest >> testLifecycleSelectorsAreClassifiedAsInitialization [
	"Verify that visual projection and rendering selectors are classified as initialization, not suspicious."
	self assert: (watchdog isLifecycleOrProjectionSelector: #createDiagramElement).
	self assert: (watchdog isLifecycleOrProjectionSelector: #showAllElements).
	self assert: (watchdog isLifecycleOrProjectionSelector: #renderIn:).
	self assert: (watchdog isLifecycleOrProjectionSelector: #createOwnedElementsWithoutController).
	self assert: (watchdog isLifecycleOrProjectionSelector: #updateAfterDiagramFocused).
	self deny: (watchdog isLifecycleOrProjectionSelector: #isWeak:)
]

{ #category : 'tests' }
OPMutationWatchdogTest >> testNakedMutationIsCaptured [

	watchdog startWatching.
	testEntity isWeak: true.
	watchdog stopWatching.

	self assert:
		(watchdog records anySatisfy: [ :each |
			 each targetClass = 'OPErdEntity' and: [ each slotName = #isWeak and: [ each newValue ] ] ])
]

{ #category : 'tests' }
OPMutationWatchdogTest >> testStartAndStopWatchingCleansSlots [
	watchdog startWatching.
	self assert: watchdog instrumentedMethods isNotEmpty.
	self assert: watchdog records isEmpty.

	watchdog stopWatching.
	self assert: watchdog instrumentedMethods isEmpty
]

{ #category : 'tests' }
OPMutationWatchdogTest >> testTransactedMutationIsNotSuspicious [
	| projectController |
	projectController := OPProjectController new.
	watchdog startWatching.
	projectController undoManager inTransaction: [ testEntity name: 'Customer' ].
	watchdog stopWatching.

	self assert: (watchdog records anySatisfy: [ :each |
		each slotName = #name and: [ each isTransacted and: [ each isSuspicious not ] ] ])
]

{ #category : 'tests' }
OPMutationWatchdogTest >> testTransientSlotAssignmentNodeIsNotInstrumented [
	"Verify that assignment nodes to transient slots are not instrumented with metalinks."
	watchdog startWatching.
	self deny: (watchdog instrumentedMethods anySatisfy: [ :assoc |
		assoc key == OPDiagramElement and: [ assoc value = #announcer ] ]).
	watchdog stopWatching
]

{ #category : 'tests' }
OPMutationWatchdogTest >> testTransientSlotFiltering [
	"Verify that transient graphical and runtime slots are recognized as transient and ignored."
	self assert: (watchdog isTransientSlot: #roassalShape onClass: OPDiagramElement).
	self assert: (watchdog isTransientSlot: #announcer onClass: OPDiagramElement).
	self assert: (watchdog isTransientSlot: #canvas onClass: OPDiagramElement).
	self assert: (watchdog isTransientSlot: #eventHandler onClass: OPDiagramElement).
	self assert: (watchdog isTransientSlot: #cache onClass: OPDiagramElement).
	self assert: (watchdog isTransientSlot: #labeled onClass: OPBoundary).
	self deny: (watchdog isTransientSlot: #name onClass: OPBoundary).
	self deny: (watchdog isTransientSlot: #bounds onClass: OPBoundNode).
	self deny: (watchdog isTransientSlot: #isWeak onClass: OPErdEntity)
]
