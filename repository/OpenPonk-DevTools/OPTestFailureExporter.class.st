"
A utility that executes a specified test and gathers its execution context, including the stack trace, relevant class hierarchies, and associated MVC triads (Model-ViewModel-Controller), formatted as a text report for debugging.

Example:
[[[
| report |
report := OPTestFailureExporter new
	runTest: OPMyFailingControllerTest
	selector: #testLayoutConfiguration.

Clipboard clipboardText: report.
report inspect.
]]]
"
Class {
	#name : 'OPTestFailureExporter',
	#superclass : 'Object',
	#instVars : [
		'testCase',
		'exception',
		'outputStream',
		'relevantClasses'
	],
	#classVars : [
		'ExportedCache'
	],
	#category : 'OpenPonk-DevTools-Export',
	#package : 'OpenPonk-DevTools',
	#tag : 'Export'
}

{ #category : 'initialization' }
OPTestFailureExporter class >> resetCache [
    <script>
    ExportedCache := Dictionary new.
]

{ #category : 'collecting' }
OPTestFailureExporter >> addHierarchyOf: aClass [

	| current |
	current := aClass.
	[ current isNotNil and: [ current name beginsWith: 'OP' ] ] whileTrue: [
			(relevantClasses includes: current) ifFalse: [
					relevantClasses add: current.
					(current name includesSubstring: 'Controller') ifTrue: [ self tryAddMvcTriadFor: current ] ].
			current := current superclass ]
]

{ #category : 'collecting' }
OPTestFailureExporter >> collectClassesFrom: aContext [

	self addHierarchyOf: aContext receiver class.
	self addHierarchyOf: aContext methodClass.
	(aContext receiver class name includesSubstring: 'Test') ifTrue: [ self tryAddMvcTriadForTargetOfTest ]
]

{ #category : 'exporting' }
OPTestFailureExporter >> exportClassSide: aClass [

	| classOutput hasChanges classDef |
	(aClass isClassSide and: [ aClass methods isEmpty ]) ifTrue: [ ^ self ].

	classOutput := WriteStream on: String new.
	hasChanges := false.

	classDef := aClass definitionString.
	(self isChanged: classDef key: aClass name asString , '_def') ifTrue: [
			classOutput nextPutAll: classDef.
			classOutput cr.
			hasChanges := true ].

	aClass selectors do: [ :selector |
			| source key |
			source := (aClass sourceCodeAt: selector) asString.
			(source includesSubstring: 'sharedGeneralizations at:') ifFalse: [
					key := String streamContents: [ :stream | stream << aClass name asString << '>>' << selector asString ].
					(self isChanged: source key: key) ifTrue: [
							classOutput cr.
							classOutput nextPutAll: source.
							classOutput cr.
							hasChanges := true ] ] ].

	hasChanges ifFalse: [ ^ self ].
	outputStream nextPutAll: classOutput contents.
	outputStream cr.
	outputStream nextPutAll: '---'.
	outputStream cr.
	outputStream cr
]

{ #category : 'exporting' }
OPTestFailureExporter >> exportClasses [

	outputStream cr.
	outputStream nextPutAll: '=== CODE SELECTION (PARTS NOT UPLOADED BEFORE) ==='.
	outputStream cr.
	outputStream cr.
	relevantClasses asArray do: [ :eachClass |
			self exportClassSide: eachClass.
			self exportClassSide: eachClass classSide ]
]

{ #category : 'exporting' }
OPTestFailureExporter >> extractStackTrace [

	| context stop |
	context := exception signalerContext.
	stop := false.
	[ context isNil or: [ stop ] ] whileFalse: [
			stop := self isStopContext: context.
			self printContext: context.
			self collectClassesFrom: context.
			context := context sender ]
]

{ #category : 'exporting' }
OPTestFailureExporter >> generateReport [

	outputStream nextPutAll: '=== EXCEPTION ==='.
	outputStream cr.
	outputStream nextPutAll: exception description.
	outputStream cr.
	outputStream cr.
	outputStream nextPutAll: '=== STACK TRACE & VARIABLES ==='.
	outputStream cr.

	self extractStackTrace.
	self exportClasses
]

{ #category : 'initialization' }
OPTestFailureExporter >> initialize [

	super initialize.
	ExportedCache ifNil: [ ExportedCache := Dictionary new ]
]

{ #category : 'testing' }
OPTestFailureExporter >> isChanged: aString key: aKey [

	| hash |
	hash := aString hash.
	^ (ExportedCache at: aKey ifAbsent: [ nil ]) = hash
		  ifFalse: [
				  ExportedCache at: aKey put: hash.
				  true ]
		  ifTrue: [ false ]
]

{ #category : 'testing' }
OPTestFailureExporter >> isStopContext: aContext [

	| sel |
	sel := aContext selector.
	^ sel = testCase selector or: [ sel = #setUp ]
]

{ #category : 'exporting' }
OPTestFailureExporter >> printContext: aContext [

	outputStream nextPutAll: '>> '.
	outputStream print: aContext.
	outputStream cr.
	outputStream nextPutAll: '   Receiver: '.
	outputStream nextPutAll: aContext receiver class name.
	outputStream cr.
	aContext temporaryVariableNames do: [ :tempName |
			| value valueString |
			value := aContext tempNamed: tempName.
			valueString := [ value printString ]
				               on: Error
				               do: [ '<error printing object>' ].
			outputStream nextPutAll: '   '.
			outputStream nextPutAll: tempName asString.
			outputStream nextPutAll: ' = '.
			outputStream nextPutAll: valueString.
			outputStream cr ].
	outputStream cr
]

{ #category : 'running' }
OPTestFailureExporter >> runTest: aTestClass selector: aSelector [

	testCase := aTestClass selector: aSelector.
	relevantClasses := Set new.
	outputStream := WriteStream on: (String new: 2000).

	[
		[
			testCase setUp.
			testCase perform: aSelector ]
			on: Error , TestFailure
			do: [ :ex |
					exception := ex.
					self generateReport.
					ex return: nil ] ] ensure: [ testCase tearDown ].

	^ outputStream contents
]

{ #category : 'collecting' }
OPTestFailureExporter >> tryAddMvcTriadFor: aControllerClass [

	| viewModelClass modelClass |
	viewModelClass := [ aControllerClass viewModelClass ]
		                  on: Error
		                  do: [ nil ].
	viewModelClass ifNil: [ ^ self ].
	self addHierarchyOf: viewModelClass.
	modelClass := [ viewModelClass modelClass ]
		              on: Error
		              do: [ nil ].
	modelClass ifNil: [ ^ self ].
	self addHierarchyOf: modelClass
]

{ #category : 'collecting' }
OPTestFailureExporter >> tryAddMvcTriadForTargetOfTest [

	| controllerClass |
	(testCase class canUnderstand: #controllerClass) ifFalse: [ ^ self ].
	controllerClass := testCase controllerClass.
	controllerClass ifNotNil: [ self addHierarchyOf: controllerClass ]
]
