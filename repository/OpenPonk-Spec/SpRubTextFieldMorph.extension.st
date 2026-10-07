Extension { #name : 'SpRubTextFieldMorph' }

{ #category : '*OpenPonk-Spec' }
SpRubTextFieldMorph >> withDropListButton [
	self flag: 'https://github.com/pharo-spec/Spec/issues/1318'.
	^ self
]
