Class {
	#name : 'OPMutationRecord',
	#superclass : 'Object',
	#instVars : [
		'timestamp',
		'targetClass',
		'targetIdentity',
		'slotName',
		'oldValue',
		'newValue',
		'isTransacted',
		'isSimulation',
		'isInitialization',
		'isUiTriggered',
		'uiPresenterClass',
		'stackTrace'
	],
	#category : 'OpenPonk-DevTools-Watchdog',
	#package : 'OpenPonk-DevTools',
	#tag : 'Watchdog'
}

{ #category : 'accessing' }
OPMutationRecord >> isInitialization [
	^ isInitialization
]

{ #category : 'accessing' }
OPMutationRecord >> isInitialization: aValue [
	isInitialization := aValue
]

{ #category : 'accessing' }
OPMutationRecord >> isSimulation [
	^ isSimulation
]

{ #category : 'accessing' }
OPMutationRecord >> isSimulation: aValue [
	isSimulation := aValue
]

{ #category : 'testing' }
OPMutationRecord >> isSuspicious [
	"Answer whether this mutation bypassed transaction control during user-facing interaction."
	^ isUiTriggered and: [ isTransacted not and: [ isSimulation not and: [ isInitialization not ] ] ]
]

{ #category : 'accessing' }
OPMutationRecord >> isTransacted [
	^ isTransacted
]

{ #category : 'accessing' }
OPMutationRecord >> isTransacted: aValue [
	isTransacted := aValue
]

{ #category : 'accessing' }
OPMutationRecord >> isUiTriggered [
	^ isUiTriggered
]

{ #category : 'accessing' }
OPMutationRecord >> isUiTriggered: aValue [
	isUiTriggered := aValue
]

{ #category : 'accessing' }
OPMutationRecord >> newValue [
	^ newValue
]

{ #category : 'accessing' }
OPMutationRecord >> newValue: aValue [
	newValue := aValue
]

{ #category : 'accessing' }
OPMutationRecord >> oldValue [
	^ oldValue
]

{ #category : 'accessing' }
OPMutationRecord >> oldValue: aValue [
	oldValue := aValue
]

{ #category : 'accessing' }
OPMutationRecord >> slotName [
	^ slotName
]

{ #category : 'accessing' }
OPMutationRecord >> slotName: aValue [
	slotName := aValue
]

{ #category : 'accessing' }
OPMutationRecord >> stackTrace [
	^ stackTrace
]

{ #category : 'accessing' }
OPMutationRecord >> stackTrace: aValue [
	stackTrace := aValue
]

{ #category : 'printing' }
OPMutationRecord >> summaryString [
	"Answer a compact textual summary of this mutation record."

	^ String streamContents: [ :s153 |
			  s153 << '[' << timestamp asTime print24 << '] ' << (self isSuspicious
				   ifTrue: [ '[SUSPICIOUS NAKED MUTATION] ' ]
				   ifFalse: [ '[OK] ' ]) << targetClass << ' >> #' << slotName << ' (' << oldValue asString << ' -> ' << newValue asString
			  << ')' << ' UI: ' << (uiPresenterClass ifNotNil: [ :theClass | theClass asString ] ifNil: [ 'none' ]) ]
]

{ #category : 'accessing' }
OPMutationRecord >> targetClass [
	^ targetClass
]

{ #category : 'accessing' }
OPMutationRecord >> targetClass: aValue [
	targetClass := aValue
]

{ #category : 'accessing' }
OPMutationRecord >> targetIdentity [
	^ targetIdentity
]

{ #category : 'accessing' }
OPMutationRecord >> targetIdentity: aValue [
	targetIdentity := aValue
]

{ #category : 'accessing' }
OPMutationRecord >> timestamp [
	^ timestamp
]

{ #category : 'accessing' }
OPMutationRecord >> timestamp: aValue [
	timestamp := aValue
]

{ #category : 'initialization' }
OPMutationRecord >> timestamp: aTime targetClass: aClass targetIdentity: anId slotName: aSlot oldValue: anOld newValue: aNew isTransacted: aTrans isSimulation: aSim isInitialization: anInit isUiTriggered: anUi uiPresenterClass: aPresenter stackTrace: aStack [
	timestamp := aTime.
	targetClass := aClass.
	targetIdentity := anId.
	slotName := aSlot.
	oldValue := anOld.
	newValue := aNew.
	isTransacted := aTrans.
	isSimulation := aSim.
	isInitialization := anInit.
	isUiTriggered := anUi.
	uiPresenterClass := aPresenter.
	stackTrace := aStack
]

{ #category : 'accessing' }
OPMutationRecord >> uiPresenterClass [
	^ uiPresenterClass
]

{ #category : 'accessing' }
OPMutationRecord >> uiPresenterClass: aValue [
	uiPresenterClass := aValue
]
