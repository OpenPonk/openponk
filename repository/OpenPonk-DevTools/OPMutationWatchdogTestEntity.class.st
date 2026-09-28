Class {
	#name : 'OPMutationWatchdogTestEntity',
	#superclass : 'Object',
	#instVars : [
		'name',
		'isWeak'
	],
	#category : 'OpenPonk-DevTools-Watchdog',
	#package : 'OpenPonk-DevTools',
	#tag : 'Watchdog'
}

{ #category : 'accessing' }
OPMutationWatchdogTestEntity >> isWeak [
	"Answer whether this watchdog test entity is weak."
	^ isWeak ifNil: [ false ]
]

{ #category : 'accessing' }
OPMutationWatchdogTestEntity >> isWeak: aBoolean [
	"Set whether this watchdog test entity is weak."
	isWeak := aBoolean
]

{ #category : 'accessing' }
OPMutationWatchdogTestEntity >> name [
	"Answer the name of this watchdog test entity."
	^ name
]

{ #category : 'accessing' }
OPMutationWatchdogTestEntity >> name: aString [
	"Set the name of this watchdog test entity."
	name := aString
]
