initialization
layoutOn: elements
	RTVerticalLineLayout new
		gapSize: 0;
		on: elements.

	name translateTo: (self background center x / 2) @ name center y.

	"
	width := self background width.
	stereotype ifNotNil: [ stereotype translateBy: ((width - stereotype width) / 2) @ 0 ].
	name ifNotNil: [ name translateBy: ((width - name width) / 2) @ 0 ]."
	self attributes hasFigures
		ifTrue: [ 
			self attributes background width: self background width.
			self attributes background translateTo: (self background center x / 2) @ self attributes background center y.
			
					"	self attributes background translateBy: ((self width - self attributes width) / 2) @ 0."
 ]
	"	self operations hasFigures
		ifTrue: [ 
			self operations background translateBy: ((self width - self operations encompassingRectangle width) / 4) @ 0.
			self operations background width: self width + (self padding x * 2) ]"