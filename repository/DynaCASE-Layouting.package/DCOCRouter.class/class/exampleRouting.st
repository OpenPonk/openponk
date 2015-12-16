examples
exampleRouting
|v es router visGraph g el seg conn conn2 r1 r2 routes ordering|
v := RTView new.
v @ (RTGridView new gridSize: 5).

es := RTBox new size: #yourself; elementsOn: #(20 40 60" 40").

v addAll: es.

es @ RTDraggable.

es second translateTo: 100 @ 50.
es third translateTo: 120 @ -20.
"es fourth translateTo: 90 @ -80."

router := DCOCRouter new.
visGraph := router visibilityGraphFor: es.

g := RTGroup new.

visGraph nodes do: [ :each |
	el := RTEllipse new color: Color red; size: 2; elementOn: each.
	each element ifNotNil: [
		el shape color: Color blue.
		el update.
	].
	g add: el.
	v add: el.
	"el @ (RTLabelled new fontSize: 4; text: #model)."
	el translateTo: each model.
].

visGraph edges do: [ :each |
	seg := RTLine new
		color: Color lightRed;
		edgeFrom: (g elementFromModel: each from) to: (g elementFromModel: each to).
	v add: seg.
	seg trachelShape pushBack.
].

conn := DCRTStyledConnection new
	color: Color black;
	edgeFrom: es first to: es second.
v add: conn.

conn2 := DCRTStyledConnection new
	color: Color purple;
	edgeFrom: es first to: es third.
v add: conn2.

r1 := router
	routeFrom: (visGraph nodes detect: [:n | n model = (20@0)])
	to: (visGraph nodes detect: [:n | n model = (70@50)])
	visibility: visGraph.

r2 := router
	routeFrom: (visGraph nodes detect: [:n | n model = (0@20)])
	to: (visGraph nodes detect: [:n | n model = (80@ -20)])
	visibility: visGraph.

routes := OrderedCollection with: r1 route with: r2 route.

ordering := router orderingFor: routes.
"routes := router collinearizeRoutes: routes.
routes := router separateRoutes: routes."

router applyRoute: routes first to: conn.	
router applyRoute: routes second to: conn2.

"r2 at: 3 put: 73@20.
r2 at: 4 put: 73@0.
r2 at: 5 put: 73@ -20."

v @ RTDraggableView @ RTZoomableView.

v