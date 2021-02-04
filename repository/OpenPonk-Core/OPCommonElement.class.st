Class {
	#name : #OPCommonElement,
	#superclass : #Object,
	#instVars : [
		'owner',
		'uuid',
		'announcer'
	],
	#category : #'OpenPonk-Core-CommonElements'
}

{ #category : #announce }
OPCommonElement >> announce: anAnnouncement [
	self announcer announce: anAnnouncement
]

{ #category : #accessing }
OPCommonElement >> announcer [
	announcer ifNil: [ announcer := Announcer new ].
	^ announcer
]

{ #category : #accessing }
OPCommonElement >> owner [
	^ owner
]

{ #category : #enumerating }
OPCommonElement >> silentlyDo: aBlock [
	| oldAnnouncer |
	oldAnnouncer := announcer.
	announcer := Announcer new.
	aBlock value.
	announcer := oldAnnouncer
]

{ #category : #accessing }
OPCommonElement >> uuid [
	^ uuid ifNil: [ uuid := UUID new ]
]

{ #category : #accessing }
OPCommonElement >> uuid: aUUID [
	uuid := aUUID
]

{ #category : #protocol }
OPCommonElement >> when: anEvent do: aBlock [
	self announcer when: anEvent do: aBlock
]

{ #category : #protocol }
OPCommonElement >> when: anAnnouncementClass send: aSelector to: anObject [
	self announcer when: anAnnouncementClass send: aSelector to: anObject
]
