accessing
data: aString
	self submorphsDo: #delete.
	aString do: [ :letter | self addMorphBack: (DCFsmLetterBox new letter: letter) ]