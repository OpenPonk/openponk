private
cornerFor: anEdge
	| c r |
	c := anEdge from position.
	r := anEdge from width / 2.	"assuming circle"
	^ c + ((self legFor: r) @ (self legFor: r)) + (self n @ self n)