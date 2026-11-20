"
Abstract base test case for Morphic and Spec UI tests that attach windows or morphs to the active world.
Cooperatively pauses the Morphic UI process at its deferred-message cycle boundary while each test runs, preventing concurrent layout and tab-update race conditions without altering the active test process, exception stack traces, or process-local test variables.
"
Class {
	#name : 'OPAbstractUITest',
	#superclass : 'TestCase',
	#classVars : [
		'PausedOwnerProcess'
	],
	#category : 'OpenPonk-Morphic-Tests-Morphic',
	#package : 'OpenPonk-Morphic-Tests',
	#tag : 'Morphic'
}

{ #category : 'testing' }
OPAbstractUITest class >> isAbstract [

	^ self == OPAbstractUITest
]

{ #category : 'running' }
OPAbstractUITest >> canPauseMorphicUIProcess [

	| uiProcess |
	PausedOwnerProcess == Processor activeProcess ifTrue: [ ^ false ].
	self currentWorld ifNil: [ ^ false ].
	uiProcess := MorphicUIManager uiProcess.
	uiProcess ifNil: [ ^ false ].
	uiProcess == Processor activeProcess ifTrue: [ ^ false ].
	^ uiProcess isTerminated not and: [ uiProcess isSuspended not ]
]

{ #category : 'running' }
OPAbstractUITest >> runCase [

	^ self withMorphicUIProcessPausedDo: [ super runCase ]
]

{ #category : 'running' }
OPAbstractUITest >> withMorphicUIProcessPausedDo: aBlock [

	| enteredSemaphore releaseSemaphore isCancelled |
	self canPauseMorphicUIProcess ifFalse: [ ^ aBlock value ].
	enteredSemaphore := Semaphore new.
	releaseSemaphore := Semaphore new.
	isCancelled := false.
	self currentWorld defer: [
			isCancelled ifFalse: [
					enteredSemaphore signal.
					releaseSemaphore wait ] ].
	(enteredSemaphore waitTimeoutSeconds: 2) ifTrue: [
			isCancelled := true.
			releaseSemaphore signal.
			^ aBlock value ].
	^ [
		  PausedOwnerProcess := Processor activeProcess.
		  aBlock value ] ensure: [
			  PausedOwnerProcess == Processor activeProcess ifTrue: [ PausedOwnerProcess := nil ].
			  releaseSemaphore signal ]
]
