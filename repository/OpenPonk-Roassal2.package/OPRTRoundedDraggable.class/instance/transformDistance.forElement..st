hooks
transformDistance: distanceAsPoint forElement: anElement
	"anElement can be at non-integer position, so account for it"

	^ (anElement position + distanceAsPoint) rounded - anElement position