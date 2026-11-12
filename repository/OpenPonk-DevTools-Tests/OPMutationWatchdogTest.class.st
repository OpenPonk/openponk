"
Tests MetaLink installation, mutation capture, and record auditing performed by the OPMutationWatchdog.
"
Class {
	#name : 'OPMutationWatchdogTest',
	#superclass : 'TestCase',
	#instVars : [
		'watchdog',
		'testEntity'
	],
	#category : 'OpenPonk-DevTools-Tests-Watchdog',
	#package : 'OpenPonk-DevTools-Tests',
	#tag : 'Watchdog'
}

{ #category : 'accessing' }
OPMutationWatchdogTest >> controllerClass [
	^ OPNoteController
]

{ #category : 'private - fixtures' }
OPMutationWatchdogTest >> failingHelperForExporterTest [
	| sampleLocalValue |
	sampleLocalValue := 42.
	self assert: sampleLocalValue equals: 0
]

{ #category : 'running' }
OPMutationWatchdogTest >> setUp [
	super setUp.
	watchdog := OPMutationWatchdog new.
	testEntity := OPMutationWatchdogTestEntity new
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
	self
		assert: (watchdog isTransientSlot: #isOpen onClass: diagramClass)
		description: '#isOpen on OPOpenPonkDiagram should be transient'.
	self
		assert: (watchdog isTransientSlot: #isSelected onClass: diagramClass)
		description: '#isSelected on OPOpenPonkDiagram should be transient'.
	self
		assert: (watchdog isTransientSlot: #camera onClass: diagramClass)
		description: '#camera on OPOpenPonkDiagram should be transient'.
	self
		assert: (watchdog isTransientSlot: #bounds onClass: diagramClass)
		description: '#bounds on OPOpenPonkDiagram should be transient'.
	self
		deny: (watchdog isTransientSlot: #bounds onClass: OPBoundNode)
		description: '#bounds on OPBoundNode is persistent geometry and must not be transient'
]

{ #category : 'tests' }
OPMutationWatchdogTest >> testExportSuspiciousReportCopiesToClipboard [
	"Verify that exportSuspiciousReport places formatted markdown into Clipboard and returns the text."
	| record report |
	record := OPMutationRecord new
		timestamp: DateAndTime now;
		targetClass: 'OPMutationWatchdogTestEntity';
		targetIdentity: '123';
		slotName: #isWeak;
		oldValue: false;
		newValue: true;
		isTransacted: false;
		isSimulation: false;
		isInitialization: false;
		isUiTriggered: true;
		uiPresenterClass: 'OPTestPresenter';
		stackTrace: #( 'OPTestPresenter >> #save' );
		yourself.
	watchdog records add: record.
	report := watchdog exportSuspiciousReport.
	self
		assert: (report includesSubstring: 'OPMutationWatchdogTestEntity >> #isWeak')
		description: 'Exported report should mention the mutated class and slot'.
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
OPMutationWatchdogTest >> testFailureExporterGeneratesReportAndDeduplicatesCode [
	| exporter firstReport secondReport |
	[
		OPTestFailureExporter resetCache.
		exporter := OPTestFailureExporter new.
		firstReport := exporter
			runTest: self class
			selector: #failingHelperForExporterTest.
		self assert: (firstReport includesSubstring: '=== EXCEPTION ===')
			description: 'First report should contain exception section'.
		self assert: (firstReport includesSubstring: 'sampleLocalValue = 42')
			description: 'First report should capture local variable value from stack context'.
		self assert: (firstReport includesSubstring: 'OPNoteController')
			description: 'First report should include MVC triad classes from controllerClass'.

		secondReport := exporter
			runTest: self class
			selector: #failingHelperForExporterTest.
		self assert: secondReport size < firstReport size
			description: 'Second report without cache reset should omit already exported class definitions and methods'
	] ensure: [ OPTestFailureExporter resetCache ]
]

{ #category : 'tests' }
OPMutationWatchdogTest >> testInvisibleOnMouseShapeSlotsAreTransient [
	"Verify that temporary edge routing feedback shapes are ignored by the watchdog."
	| invisibleShapeClass |
	invisibleShapeClass := OPInvisibleOnMouseShape.
	self
		assert: (watchdog isTransientSlot: #bounds onClass: invisibleShapeClass)
		description: '#bounds on OPInvisibleOnMouseShape should be transient'.
	self
		assert: (watchdog isTransientSlot: #owningElement onClass: invisibleShapeClass)
		description: '#owningElement on OPInvisibleOnMouseShape should be transient'
]

{ #category : 'tests' }
OPMutationWatchdogTest >> testIsExternalTestContext [
	"Verify that thisContext inside OPMutationWatchdogTest is recognized as NOT external."
	self
		deny: (watchdog isExternalTestContext: thisContext)
		description: 'Context inside OPMutationWatchdogTest should not be treated as an external test context'
]

{ #category : 'tests' }
OPMutationWatchdogTest >> testLifecycleSelectorsAreClassifiedAsInitialization [
	"Verify that visual projection and rendering selectors are classified as initialization, not suspicious."
	self
		assert: (watchdog isLifecycleOrProjectionSelector: #createDiagramElement)
		description: '#createDiagramElement should be recognized as lifecycle selector'.
	self
		assert: (watchdog isLifecycleOrProjectionSelector: #showAllElements)
		description: '#showAllElements should be recognized as lifecycle selector'.
	self
		assert: (watchdog isLifecycleOrProjectionSelector: #renderIn:)
		description: '#renderIn: should be recognized as lifecycle selector'.
	self
		assert: (watchdog isLifecycleOrProjectionSelector: #createOwnedElementsWithoutController)
		description: '#createOwnedElementsWithoutController should be recognized as lifecycle selector'.
	self
		assert: (watchdog isLifecycleOrProjectionSelector: #updateAfterDiagramFocused)
		description: '#updateAfterDiagramFocused should be recognized as lifecycle selector'.
	self
		deny: (watchdog isLifecycleOrProjectionSelector: #isWeak:)
		description: 'Domain mutator #isWeak: must not be classified as lifecycle selector'
]

{ #category : 'tests' }
OPMutationWatchdogTest >> testNakedMutationIsCaptured [
	watchdog startWatching.
	testEntity isWeak: true.
	watchdog stopWatching.
	self
		assert:
			(watchdog records anySatisfy: [ :eachRecord |
				eachRecord targetClass = 'OPMutationWatchdogTestEntity'
					and: [ eachRecord slotName = #isWeak and: [ eachRecord newValue ] ] ])
		description: 'Naked mutation of #isWeak outside transaction should be recorded by watchdog'
]

{ #category : 'tests' }
OPMutationWatchdogTest >> testStartAndStopWatchingCleansSlots [

	watchdog startWatching.
	self denyEmpty: watchdog instrumentedMethods.
	self assertEmpty: watchdog records.

	watchdog stopWatching.
	self assertEmpty: watchdog instrumentedMethods
]

{ #category : 'tests' }
OPMutationWatchdogTest >> testTransactedMutationIsNotSuspicious [
	| projectController |
	projectController := OPProjectController new.
	watchdog startWatching.
	projectController undoManager inTransaction: [ testEntity name: 'Customer' ].
	watchdog stopWatching.
	self
		assert:
			(watchdog records anySatisfy: [ :eachRecord |
				eachRecord slotName = #name
					and: [ eachRecord isTransacted and: [ eachRecord isSuspicious not ] ] ])
		description: 'Mutation inside OPUndoManager transaction must be marked transacted and not suspicious'
]

{ #category : 'tests' }
OPMutationWatchdogTest >> testTransientSlotAssignmentNodeIsNotInstrumented [
	"Verify that assignment nodes to transient slots are not instrumented with metalinks."
	watchdog startWatching.
	self
		deny:
			(watchdog instrumentedMethods anySatisfy: [ :assoc |
				assoc key == OPDiagramElement and: [ assoc value = #announcer ] ])
		description: 'Transient slot #announcer on OPDiagramElement must not be instrumented'.
	watchdog stopWatching
]

{ #category : 'tests' }
OPMutationWatchdogTest >> testTransientSlotFiltering [
	"Verify that transient graphical and runtime slots are recognized as transient and ignored."
	self
		assert: (watchdog isTransientSlot: #roassalShape onClass: OPDiagramElement)
		description: '#roassalShape should be transient'.
	self
		assert: (watchdog isTransientSlot: #announcer onClass: OPDiagramElement)
		description: '#announcer should be transient'.
	self
		assert: (watchdog isTransientSlot: #canvas onClass: OPDiagramElement)
		description: '#canvas should be transient'.
	self
		assert: (watchdog isTransientSlot: #eventHandler onClass: OPDiagramElement)
		description: '#eventHandler should be transient'.
	self
		assert: (watchdog isTransientSlot: #cache onClass: OPDiagramElement)
		description: '#cache should be transient'.
	self
		assert: (watchdog isTransientSlot: #labeled onClass: OPBoundary)
		description: '#labeled on OPBoundary should be transient'.
	self
		deny: (watchdog isTransientSlot: #name onClass: OPBoundary)
		description: '#name on OPBoundary must not be transient'.
	self
		deny: (watchdog isTransientSlot: #bounds onClass: OPBoundNode)
		description: '#bounds on OPBoundNode must not be transient'.
	self
		deny: (watchdog isTransientSlot: #isWeak onClass: OPMutationWatchdogTestEntity)
		description: '#isWeak on OPMutationWatchdogTestEntity must not be transient'
]

{ #category : 'tests' }
OPMutationWatchdogTest >> testWatchdogPresenterWorkflow [
	| presenter entity suspiciousRecord stackText oldClip exportedText |
	oldClip := Clipboard clipboardText.
	[
		OPMutationWatchdog reset.
		presenter := OPMutationWatchdogPresenter new.
		self assert: OPMutationWatchdogPresenter title equals: 'OpenPonk Uncommanded Mutation Watchdog'.
		self assert: OPMutationWatchdogPresenter defaultPreferredExtent equals: 1000 @ 700.

		presenter startWatching.
		entity := OPMutationWatchdogTestEntity new.
		entity name: 'UncommandedChange'.
		entity isWeak: true.
		self assert: entity name equals: 'UncommandedChange'.
		self assert: entity isWeak description: 'isWeak should be true after assignment'.
		presenter stopWatching.

		self denyEmpty: OPMutationWatchdog default suspiciousRecords.
		suspiciousRecord := OPMutationWatchdog default suspiciousRecords first.
		self assert: suspiciousRecord isUiTriggered description: 'Captured record should report isUiTriggered'.
		self assert: suspiciousRecord timestamp isNotNil description: 'Captured record should have a timestamp'.
		self assert: (suspiciousRecord summaryString includesSubstring: 'OPMutationWatchdogTestEntity')
			description: 'Record summaryString should include target class name'.

		presenter updateStackFor: suspiciousRecord.
		stackText := (presenter instVarNamed: #stackPresenter) text asString.
		self assert: (stackText includesSubstring: 'OPMutationWatchdogTestEntity')
			description: 'Stack presenter should format target class details'.
		presenter updateStackFor: nil.
		self assertEmpty: (presenter instVarNamed: #stackPresenter) text asString.

		exportedText := presenter copyReportToClipboard.
		self assert: (exportedText includesSubstring: 'OPMutationWatchdogTestEntity')
			description: 'Exported report should contain the suspicious mutation'.
		self assert: (OPMutationWatchdog default report includesSubstring: 'Suspicious (naked UI) mutations:')
			description: 'Text report should contain suspicious header'.

		presenter clearLog.
		self assertEmpty: OPMutationWatchdog default records
	] ensure: [
		OPMutationWatchdog reset.
		Clipboard clipboardText: oldClip ]
]
