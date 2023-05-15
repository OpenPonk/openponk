Extension { #name : #Announcer }

{ #category : #'*OpenPonk-Roassal3' }
Announcer >> suspendAllOf: anObject while: aBlock [

	| originalSubscriptions result |
	originalSubscriptions := OrderedCollection new.
	self subscriptions
		subscriptionsOf: anObject
		do: [ :each | originalSubscriptions add: each copy ].
	self unsubscribe: anObject.
	result := aBlock value.
	originalSubscriptions do: [ :each | self basicSubscribe: each ].
	^ result
]
