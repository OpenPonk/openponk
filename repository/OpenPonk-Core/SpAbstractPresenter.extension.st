Extension { #name : 'SpAbstractPresenter' }

{ #category : '*OpenPonk-Core' }
SpAbstractPresenter >> whenWindowClosedDo: aBlock [

	self withWindowEnsureDo: [ :window | window whenClosedDo: aBlock ]
]

{ #category : '*OpenPonk-Core' }
SpAbstractPresenter >> whenWindowClosedUnsubscribeFrom: anObject [

	self whenWindowClosedDo: [ anObject announcer unsubscribe: self ]
]

{ #category : '*OpenPonk-Core' }
SpAbstractPresenter >> withWindowEnsureDo: aBlock [

	self hasWindow ifFalse: [
		^ self whenBuiltDo: [ aBlock value: self root ] ].

	aBlock value: self root
]
