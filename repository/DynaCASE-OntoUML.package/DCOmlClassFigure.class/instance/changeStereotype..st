private
changeStereotype: aString
	stereotype
		ifNil: [ 
			stereotype := self newStereotypeFigure.
			self addFirst: stereotype ].
	stereotype model: aString.
	stereotype update.
	self update