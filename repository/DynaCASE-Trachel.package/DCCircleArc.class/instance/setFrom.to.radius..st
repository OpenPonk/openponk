initialization
setFrom: aFromPoint to: aToPoint radius: aNumber
	from := aFromPoint.
	to := aToPoint.
	circle := (DCCircle circlesFor: aFromPoint and: aToPoint radius: aNumber) last