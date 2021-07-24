Class {
	#name : #OPCommonElement,
	#superclass : #Object,
	#instVars : [
		'uuid',
		'announcer'
	],
	#category : #'OpenPonk-Core-CommonElements'
}

{ #category : #accessing }
OPCommonElement class >> neoJsonMapping: mapper [

	mapper
		for: self do: [ :mapping | 
			mapping mapInstVars:
					mapping identifier allInstVarNames \ #( announcer ).
			(mapping mapInstVar: #uuid) valueSchema: UUID.
			mapping
				mapProperty: #className
				getter: [ :object | object className ]
				setter: [ :object :value | 
					object assert: object className = value ] ];
		for: UUID customDo: [ :mapping | 
			mapping
				encoder: [ :uuid | uuid asString ];
				decoder: [ :string | 
					[ UUID fromString: string ]
						on: Error
						do: [ string ] ] ]
]

{ #category : #announce }
OPCommonElement >> announce: anAnnouncement [
	self announcer announce: anAnnouncement
]

{ #category : #accessing }
OPCommonElement >> announcer [
	announcer ifNil: [ announcer := Announcer new ].
	^ announcer
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
