initialization
setFrom: aFromPoint to: aToPoint radius: aNumber
	from := aFromPoint.
	to := aToPoint.
	circle := (OPCircle circlesFor: aFromPoint and: aToPoint radius: aNumber) last