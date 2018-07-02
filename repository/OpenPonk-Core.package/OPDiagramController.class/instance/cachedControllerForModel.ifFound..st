controllers management
cachedControllerForModel: aModel ifFound: aFoundBlock
	| ctrl |
	modelToControllerCache
		ifNil: [ modelToControllerCache := Dictionary new.
			self controllers do: [ :each | modelToControllerCache at: each model put: each ] ].
	ctrl := modelToControllerCache at: aModel ifPresent: #yourself.
	(self controllers includes: ctrl)
		ifTrue: [ ^ aFoundBlock value: ctrl ].
	self controllers
		detect: [ :fresh | fresh model = aModel ]
		ifFound: [ :found | 
			modelToControllerCache at: aModel put: found.
			aFoundBlock value: found ]