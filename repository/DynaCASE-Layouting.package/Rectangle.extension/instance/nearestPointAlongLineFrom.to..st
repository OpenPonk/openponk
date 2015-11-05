*DynaCASE-Layouting
nearestPointAlongLineFrom: p1 to: p2
	"Note this will give points beyond the endpoints."

	^ (self corners collect: [ :point | point nearestPointAlongLineFrom: p1 to: p2 ]) min