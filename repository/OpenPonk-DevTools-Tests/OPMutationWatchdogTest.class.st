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

{ #category : 'private - fixtures' }
OPMutationWatchdogTest >> exampleCallbackBlockFor: anEntity [

	^ [ anEntity name: 'MutatedFromEscapedCallback' ]
]

{ #category : 'private - fixtures' }
OPMutationWatchdogTest >> exampleInitializationHelper [

	testEntity name: 'Initialized'
]

{ #category : 'private - fixtures' }
OPMutationWatchdogTest >> execute: aBlock [

	^ aBlock value
]

{ #category : 'private - fixtures' }
OPMutationWatchdogTest >> helperWithOldValTemp [

	| oldVal variableNode |
	oldVal := 'previousValue'.
	variableNode := (OPMutationWatchdogTestEntity >> #name:) ast assignmentNodes first variable.
	^ watchdog extractOldValueFrom: thisContext for: variableNode
]

{ #category : 'running' }
OPMutationWatchdogTest >> setUp [

	super setUp.
	watchdog := OPMutationWatchdog new.
	watchdog targetClasses: { OPMutationWatchdogTestEntity }.
	testEntity := OPMutationWatchdogTestEntity new
]

{ #category : 'private - fixtures' }
OPMutationWatchdogTest >> simulateMutationOn: aBlock [

	^ aBlock value
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
OPMutationWatchdogTest >> testCaptureWriteIgnoredWhenNotWatching [

	| assignmentNode |
	assignmentNode := (OPMutationWatchdogTestEntity >> #name:) ast assignmentNodes first.
	watchdog captureWriteOn: testEntity node: assignmentNode context: thisContext.
	self assertEmpty: watchdog records.

	watchdog startWatching.
	watchdog
		captureWriteOn: OPDiagramElement new
		node: (OPDiagramElement >> #announcer) ast assignmentNodes first
		context: thisContext.
	watchdog stopWatching.
	self assertEmpty: watchdog records
]

{ #category : 'tests' }
OPMutationWatchdogTest >> testDefaultTargetClassesExcludesTestHelpers [

	| defaultWatchdog classes |
	defaultWatchdog := OPMutationWatchdog new.
	classes := defaultWatchdog targetClasses.

	self denyCollection: classes includesAny: {
			OPMutationWatchdogTestEntity.
			OPInvisibleOnMouseShape.
			OPTestBoundNode }.
	self assert: (classes noneSatisfy: #isTrait) description: 'Default target classes must not include traits'.
	self assertCollection: classes includesAll: {
			OPBoundNode.
			OPNote }
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
OPMutationWatchdogTest >> testEscapedCallbackCreatedInInitializationIsStillSuspicious [

	| callback record |
	callback := self exampleCallbackBlockFor: testEntity.
	watchdog startWatching.
	callback value.
	watchdog stopWatching.

	record := watchdog records detect: [ :each | each newValue = 'MutatedFromEscapedCallback' ] ifNone: [ nil ].
	self assert: record isNotNil description: 'Mutation inside escaped callback should be recorded'.
	self
		deny: record isInitialization
		description:
		'Escaped block closure created in an initialization method must not be classified as initialization when invoked later'.
	self assert: record isSuspicious description: 'Naked mutation from an escaped callback must be classified as suspicious'
]

{ #category : 'tests' }
OPMutationWatchdogTest >> testExportSuspiciousReportCopiesToClipboard [
	"Verify that exportSuspiciousReport places formatted markdown into Clipboard and returns the text."

	| record report oldClip |
	oldClip := Clipboard clipboardText.
	[
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
		self assert: Clipboard clipboardText equals: report ] ensure: [ Clipboard clipboardText: oldClip ]
]

{ #category : 'tests' }
OPMutationWatchdogTest >> testExternalTestCaseMutationsAreIgnored [
	"Verify that slot writes occurring during execution of an external TestCase are ignored."

	| recordsCountBefore |
	watchdog targetClasses: {
			OPBoundNode.
			OPMutationWatchdogTestEntity }.
	watchdog startWatching.
	recordsCountBefore := watchdog records size.
	OPDiagramControllerTest run: #testShowModelInDiagram.
	watchdog stopWatching.
	self assert: watchdog records size equals: recordsCountBefore
]

{ #category : 'tests' }
OPMutationWatchdogTest >> testExtractOldValueHandlesNonInstanceVarAndOldValTemp [

	| tempVariableNode |
	tempVariableNode := (self class >> #helperWithOldValTemp) ast assignmentNodes first variable.
	self assert: (watchdog extractOldValueFrom: thisContext for: tempVariableNode) equals: nil.
	self assert: self helperWithOldValTemp equals: 'previousValue'
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
OPMutationWatchdogTest >> testIsInitializationMethodRecognizesAllCategories [

	self
		assert: (watchdog isInitializationMethod: OPMutationWatchdog >> #initialize)
		description: '#initialize should be recognized as initialization'.
	self
		assert: (watchdog isInitializationMethod: AthensSurfaceExamples >> #renderOn:)
		description: 'Methods on *Examples classes should be recognized as initialization'.
	self
		assert: (watchdog isInitializationMethod: OPControllerFactory >> #handlerKindName)
		description: 'Methods on *Factory classes should be recognized as initialization'.
	self
		assert: (watchdog isInitializationMethod: OPProjectDirectoryMaterializer >> #exporter)
		description: 'Methods on *Materializer* classes should be recognized as initialization'.
	self
		assert: (watchdog isInitializationMethod: STONReader >> #parseSimpleValue)
		description: 'Methods on *Reader* classes should be recognized as initialization'.
	self
		assert: (watchdog isInitializationMethod: self class >> #exampleInitializationHelper)
		description: 'Methods starting with example* should be recognized as initialization'.
	self
		deny: (watchdog isInitializationMethod: OPMutationWatchdogTestEntity >> #isWeak:)
		description: 'Regular domain setter must not be classified as initialization'
]

{ #category : 'tests' }
OPMutationWatchdogTest >> testIsTransactedMethodRejectsUnrelatedExecuteMethods [

	self
		assert: (watchdog isTransactedMethod: OPCommand >> #execute)
		description: 'OPCommand methods must be recognized as transacted'.
	self
		assert: (watchdog isTransactedMethod: OPUndoManager >> #inTransaction:)
		description: 'OPUndoManager>>#inTransaction: must be recognized as transacted'.
	self
		assert: (watchdog isTransactedMethod: OPUndoManager >> #execute:)
		description: 'OPUndoManager>>#execute: must be recognized as transacted'.
	self
		deny: (watchdog isTransactedMethod: self class >> #execute:)
		description: 'Unrelated #execute: methods outside OPUndoManager must not be classified as transacted'
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
OPMutationWatchdogTest >> testPopulateContextInfoMarksSimulationAndInitialization [

	| simulationRecord initializationRecord |
	watchdog startWatching.
	self simulateMutationOn: [ testEntity name: 'Simulated' ].
	self exampleInitializationHelper.
	watchdog stopWatching.

	simulationRecord := watchdog records detect: [ :each | each newValue = 'Simulated' ] ifNone: [ nil ].
	self assert: simulationRecord isNotNil description: 'Simulated mutation should be recorded'.
	self assert: simulationRecord isSimulation description: 'Mutation inside simulate* frame should be marked simulation'.
	self deny: simulationRecord isSuspicious description: 'Simulated mutation must not be suspicious'.

	initializationRecord := watchdog records detect: [ :each | each newValue = 'Initialized' ] ifNone: [ nil ].
	self assert: initializationRecord isNotNil description: 'Initialization mutation should be recorded'.
	self assert: initializationRecord isInitialization description: 'Mutation inside example* frame should be marked initialization'.
	self deny: initializationRecord isSuspicious description: 'Initialization mutation must not be suspicious'
]

{ #category : 'tests' }
OPMutationWatchdogTest >> testReadSlotReturnsNilForMissingSlot [

	self assert: (watchdog readSlot: #nonExistentSlot from: testEntity) equals: nil
]

{ #category : 'tests' }
OPMutationWatchdogTest >> testRecordSummaryStringFormatsOkAndUiPresenter [

	| record summary |
	record := OPMutationRecord new
		          timestamp: DateAndTime now;
		          targetClass: 'OPMutationWatchdogTestEntity';
		          targetIdentity: '42';
		          slotName: #name;
		          oldValue: 'Old';
		          newValue: 'New';
		          isTransacted: true;
		          isSimulation: false;
		          isInitialization: false;
		          isUiTriggered: true;
		          uiPresenterClass: 'OPPropertiesForm';
		          stackTrace: #(  );
		          yourself.
	summary := record summaryString.
	self assert: (summary includesSubstring: '[OK]') description: 'Non-suspicious record summary should include [OK]'.
	self
		assert: (summary includesSubstring: 'UI: OPPropertiesForm')
		description: 'Record summary should display non-nil UI presenter class'
]

{ #category : 'tests' }
OPMutationWatchdogTest >> testReportForLlmWhenNoSuspiciousRecords [

	| report |
	report := watchdog reportForLlm.
	self
		assert: (report includesSubstring: 'No suspicious uncommanded mutations recorded.')
		description: 'Empty suspicious report should state that no suspicious mutations were recorded'
]

{ #category : 'tests' }
OPMutationWatchdogTest >> testShouldIgnoreWriteForTransientSlot [

	self
		assert: (watchdog shouldIgnoreWriteOn: OPDiagramElement new slot: #announcer context: thisContext)
		description: 'Writes to transient slots should be ignored'
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
OPMutationWatchdogTest >> testStopWatchingCleansTraitedClassMethodsAndReflectiveMethods [

	| note compiledMethod |
	watchdog targetClasses: { OPNote }.
	watchdog startWatching.
	note := OPNote new.
	note text: 'Watchdog traited test'.
	watchdog stopWatching.

	compiledMethod := OPNote >> #text:.
	self deny: (compiledMethod isKindOf: ReflectiveMethod) description: 'stopWatching must remove ReflectiveMethod from methodDict'.
	self assert: compiledMethod reflectiveMethod equals: nil.
	self assert: (OPNote localMethodDict at: #text:) identicalTo: compiledMethod
]

{ #category : 'tests' }
OPMutationWatchdogTest >> testSuspiciousRecordsExcludesNonUiTriggeredRecords [

	| record |
	record := OPMutationRecord new
		          timestamp: DateAndTime now;
		          targetClass: 'OPMutationWatchdogTestEntity';
		          targetIdentity: '1';
		          slotName: #name;
		          oldValue: nil;
		          newValue: 'Changed';
		          isTransacted: false;
		          isSimulation: false;
		          isInitialization: false;
		          isUiTriggered: false;
		          uiPresenterClass: nil;
		          stackTrace: #(  );
		          yourself.
	watchdog records add: record.

	self assertEmpty: watchdog suspiciousRecords
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

	watchdog targetClasses: { OPDiagramElement }.
	watchdog startWatching.
	self
		deny: (watchdog instrumentedMethods anySatisfy: [ :assoc | assoc key == OPDiagramElement and: [ assoc value = #announcer ] ])
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

	| presenter defaultPresenter entity suspiciousRecord stackText oldClip previousDefault tablePresenter columnValues |
	oldClip := Clipboard clipboardText.
	previousDefault := OPMutationWatchdogPresenter classVarNamed: #Default.
	[
		OPMutationWatchdog reset.
		OPMutationWatchdog default targetClasses: { OPMutationWatchdogTestEntity }.
		OPMutationWatchdogPresenter classVarNamed: #Default put: nil.

		defaultPresenter := OPMutationWatchdogPresenter default.
		self assert: OPMutationWatchdogPresenter default identicalTo: defaultPresenter.
		presenter := defaultPresenter.
		self assert: OPMutationWatchdogPresenter title equals: 'OpenPonk Uncommanded Mutation Watchdog'.
		self assert: OPMutationWatchdogPresenter defaultPreferredExtent equals: 1000 @ 700.
		self assert: (presenter defaultLayout isKindOf: SpBoxLayout) description: 'Presenter defaultLayout should return an SpBoxLayout'.

		(presenter instVarNamed: #startButton) click.
		entity := OPMutationWatchdogTestEntity new.
		entity name: 'UncommandedChange'.
		entity isWeak: true.
		self assert: entity name equals: 'UncommandedChange'.
		self assert: entity isWeak description: 'isWeak should be true after assignment'.
		(presenter instVarNamed: #stopButton) click.

		self denyEmpty: OPMutationWatchdog default suspiciousRecords.
		suspiciousRecord := OPMutationWatchdog default suspiciousRecords first.
		self assert: suspiciousRecord isUiTriggered description: 'Captured record should report isUiTriggered'.
		self assert: suspiciousRecord timestamp isNotNil description: 'Captured record should have a timestamp'.
		self
			assert: (suspiciousRecord summaryString includesSubstring: 'OPMutationWatchdogTestEntity')
			description: 'Record summaryString should include target class name'.

		tablePresenter := presenter instVarNamed: #table.
		columnValues := tablePresenter columns collect: [ :column | column evaluation value: suspiciousRecord ] as: Array.
		self assert: columnValues second equals: 'OPMutationWatchdogTestEntity'.
		self assert: columnValues fifth equals: 'none'.

		tablePresenter selectIndex: 1.
		stackText := (presenter instVarNamed: #stackPresenter) text asString.
		self
			assert: (stackText includesSubstring: 'OPMutationWatchdogTestEntity')
			description: 'Selecting table row should format target class details in stack presenter'.
		presenter updateStackFor: nil.
		self assertEmpty: (presenter instVarNamed: #stackPresenter) text asString.

		(presenter instVarNamed: #copyButton) click.
		self
			assert: (Clipboard clipboardText asString includesSubstring: 'OPMutationWatchdogTestEntity')
			description: 'Copy button should place the suspicious report on the clipboard'.
		self
			assert: (OPMutationWatchdog default report includesSubstring: 'Suspicious (naked UI) mutations:')
			description: 'Text report should contain suspicious header'.

		(presenter instVarNamed: #clearButton) click.
		self assertEmpty: OPMutationWatchdog default records ] ensure: [
			OPMutationWatchdog reset.
			OPMutationWatchdogPresenter classVarNamed: #Default put: previousDefault.
			Clipboard clipboardText: oldClip ]
]

{ #category : 'tests' }
OPMutationWatchdogTest >> testWritesAnyInstanceVariableReturnsFalseForSlotlessClass [

	self
		deny: (watchdog writesAnyInstanceVariable: Object >> #yourself in: Object)
		description: 'Classes with zero instance variables cannot write instance variable slots'
]
