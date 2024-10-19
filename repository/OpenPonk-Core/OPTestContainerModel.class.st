"
I am a mock representing a tree inner node entity.
"
Class {
	#name : 'OPTestContainerModel',
	#superclass : 'Model',
	#instVars : [
		'entities',
		'uuid',
		'name'
	],
	#category : 'OpenPonk-Core-Controllers-Tests',
	#package : 'OpenPonk-Core',
	#tag : 'Controllers-Tests'
}

{ #category : 'accessing' }
OPTestContainerModel >> add: anEntity [

	^ entities add: anEntity
]

{ #category : 'accessing' }
OPTestContainerModel >> allElements [

	^ self entities
]

{ #category : 'accessing' }
OPTestContainerModel >> entities [
	^ entities
]

{ #category : 'initialization' }
OPTestContainerModel >> initialize [
	super initialize.
	entities := OrderedCollection new
]

{ #category : 'initialization' }
OPTestContainerModel >> name [
	^ 'container'
]

{ #category : 'subscription' }
OPTestContainerModel >> unsubscribe: anOPTestDiagramController [

	self announcer unsubscribe: anOPTestDiagramController
]

{ #category : 'accessing' }
OPTestContainerModel >> uuid [
	^ uuid ifNil: [ uuid := UUID new ]
]

{ #category : 'accessing' }
OPTestContainerModel >> uuid: anObject [
	uuid := anObject
]

{ #category : 'accessing' }
OPTestContainerModel >> when: anAnnouncement do: aBlock for: aSubscriber [

	^ self announcer when: anAnnouncement do: aBlock for: aSubscriber
]

{ #category : 'accessing' }
OPTestContainerModel >> when: anAnnouncementClass send: aSelector to: aReceiver [

	^ self announcer
		  when: anAnnouncementClass
		  send: aSelector
		  to: aReceiver
]
