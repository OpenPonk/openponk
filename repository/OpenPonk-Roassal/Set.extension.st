Extension { #name : #Set }

{ #category : #'*OpenPonk-Roassal' }
Set >> asGroup [

	^ (RSGroup new: self size)
		  addAll: self;
		  yourself
]
