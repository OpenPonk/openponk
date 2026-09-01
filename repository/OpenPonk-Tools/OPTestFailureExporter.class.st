"
I am a utility that executes a specified test and gathers its execution context, including the stack trace, relevant class hierarchies, and associated MVC triads (Model-ViewModel-Controller). I export this gathered context as a formatted text report intended to be used as a prompt payload for Large Language Models (LLMs) to aid in debugging and code generation.

Example:
[[[
| report |
report := TestFailureExporter new 
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
	#category : 'OpenPonk-Tools-Export',
	#package : 'OpenPonk-Tools',
	#tag : 'Export'
}

{ #category : 'initialization' }
OPTestFailureExporter class >> resetCache [
    <script>
    ExportedCache := Dictionary new.
]

{ #category : 'adding' }
OPTestFailureExporter >> addHierarchyOf: aClass [
    | current |
    current := aClass.
    [ current notNil and: [ current name beginsWith: 'OP' ] ] whileTrue: [
        (relevantClasses includes: current) ifFalse: [
            relevantClasses add: current.
            (current name includesSubstring: 'Controller') ifTrue: [ 
                self tryAddMvcTriadFor: current ] ].
        current := current superclass ].
]

{ #category : 'as yet unclassified' }
OPTestFailureExporter >> collectClassesFrom: aContext [
    self addHierarchyOf: aContext receiver class.
    self addHierarchyOf: aContext methodClass.
    
    (aContext receiver class name includesSubstring: 'Test') ifTrue: [ 
        self tryAddMvcTriadForTargetOfTest ].
]

{ #category : 'as yet unclassified' }
OPTestFailureExporter >> exportClassSide: aClass [
    | classOutput hasChanges classDef |
    (aClass isClassSide and: [ aClass methods isEmpty ]) ifTrue: [ ^ self ].
    
    classOutput := WriteStream on: String new.
    hasChanges := false.
    
    classDef := aClass definitionString.
    (self isChanged: classDef key: aClass name asString , '_def') ifTrue: [
        classOutput nextPutAll: classDef; cr.
        hasChanges := true ].
        
    aClass selectors do: [ :sel |
        | source key |
        source := (aClass sourceCodeAt: sel) asString.
        (source includesSubstring: 'sharedGeneralizations at:') ifFalse: [
            key := aClass name asString , '>>' , sel asString.
            (self isChanged: source key: key) ifTrue: [
                classOutput cr; nextPutAll: source; cr.
                hasChanges := true ] ] ].
                
    hasChanges ifTrue: [
        outputStream 
            nextPutAll: classOutput contents; 
            cr; nextPutAll: '---'; cr; cr ].
]

{ #category : 'as yet unclassified' }
OPTestFailureExporter >> exportClasses [
    outputStream cr; nextPutAll: '=== CODE SELECTION (PARTS NOT UPLOADED BEFORE) ==='; cr; cr.
    relevantClasses asArray do: [ :cls |
        self exportClassSide: cls.
        self exportClassSide: cls classSide ].
]

{ #category : 'as yet unclassified' }
OPTestFailureExporter >> extractStackTrace [
    | ctx stop |
    ctx := exception signalerContext.
    stop := false.
    [ ctx isNil or: [ stop ] ] whileFalse: [
        stop := self isStopContext: ctx.
        self printContext: ctx.
        self collectClassesFrom: ctx.
        ctx := ctx sender ].
]

{ #category : 'as yet unclassified' }
OPTestFailureExporter >> generateReport [

	outputStream
		nextPutAll: '=== EXCEPTION ===';
		cr;
		nextPutAll: exception description;
		cr;
		cr;
		nextPutAll: '=== STACK TRACE & VARIABLES ===';
		cr.

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

{ #category : 'printing' }
OPTestFailureExporter >> printContext: aContext [

	outputStream
		nextPutAll: '>> ';
		nextPutAll: aContext printString;
		cr;
		nextPutAll: '   Receiver: ';
		nextPutAll: aContext receiver class name;
		cr.

	aContext tempNames do: [ :tempName |
			| val valString |
			val := aContext tempNamed: tempName.
			valString := [ val printString ]
				             on: Error
				             do: [ '<error printing object>' ].
			outputStream
				nextPutAll: '   ';
				nextPutAll: tempName;
				nextPutAll: ' = ';
				nextPutAll: valString;
				cr ].
	outputStream cr
]

{ #category : 'as yet unclassified' }
OPTestFailureExporter >> runTest: aTestClass selector: aSelector [

	testCase := aTestClass selector: aSelector.
	relevantClasses := Set new.
	outputStream := WriteStream on: (String new: 2000).
	self initialize.

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

{ #category : 'as yet unclassified' }
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

{ #category : 'as yet unclassified' }
OPTestFailureExporter >> tryAddMvcTriadForTargetOfTest [

	| ctrlClass |
	(testCase respondsTo: #controllerClass) ifFalse: [ ^ self ].
	ctrlClass := testCase controllerClass.
	ctrlClass ifNotNil: [ self addHierarchyOf: ctrlClass ]
]
