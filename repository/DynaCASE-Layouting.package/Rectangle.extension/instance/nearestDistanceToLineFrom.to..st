*DynaCASE-Layouting
nearestDistanceToLineFrom: p1 to: p2
	"Note this will give points beyond the endpoints."

	^ (self corners collect: [ :point | point dist: (point nearestPointOnLineFrom: p1 to: p2) ])
		min