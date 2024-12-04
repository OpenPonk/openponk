Class {
	#name : 'OPTestAbstractModel',
	#superclass : 'Model',
	#instVars : [
		'uuid'
	],
	#category : 'OpenPonk-Core-Controllers-Tests',
	#package : 'OpenPonk-Core',
	#tag : 'Controllers-Tests'
}

{ #category : 'comparing' }
OPTestAbstractModel >> = other [

	^ other isNotNil and: [
		  self uuid = other uuid and: [ self name = other name ] ]
]

{ #category : 'accessing' }
OPTestAbstractModel >> name [
	^ 'model'
]

{ #category : 'subscription' }
OPTestAbstractModel >> unsubscribe: anOPTestDiagramController [

	self announcer unsubscribe: anOPTestDiagramController
]

{ #category : 'accessing' }
OPTestAbstractModel >> uuid [

	^ uuid ifNil: [ uuid := UUID new ]
]

{ #category : 'accessing' }
OPTestAbstractModel >> uuid: aStringOrUUID [
	uuid := aStringOrUUID isString
		ifTrue: [ UUID fromString: aStringOrUUID ]
		ifFalse: [ aStringOrUUID ]
]

{ #category : 'accessing' }
OPTestAbstractModel >> when: anAnnouncement do: aBlock for: aSubscriber [

	^ self announcer when: anAnnouncement do: aBlock for: aSubscriber
]

{ #category : 'announcer' }
OPTestAbstractModel >> when: anAnnouncementClass send: aSelector to: aReceiver [

	^ self announcer
		  when: anAnnouncementClass
		  send: aSelector
		  to: aReceiver
]
