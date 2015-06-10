adding
changeLines: aString
	"change all the lines with aString"

	self figures copy do: [ :each | self remove: each ].
	aString lines do: [ :each | self addLine: each ]