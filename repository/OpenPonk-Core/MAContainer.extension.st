Extension { #name : #MAContainer }

{ #category : #'*OpenPonk-Core' }
MAContainer >> definingContext [
	
	^ self propertyAt: #definingContext ifAbsent: [ nil ]
]

{ #category : #'*OpenPonk-Core' }
MAContainer >> definingContext: anMADefiningContext [
	
	^ self propertyAt: #definingContext  put: anMADefiningContext
]
