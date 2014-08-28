as yet unclassified
positionFor: anElement
	"^ anElement trachelShape center"

	| from to |
	from := anElement from trachelShape center.
	to := anElement to trachelShape center.
	^ (from rectangle: to) center