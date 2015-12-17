hook
doExecute: els
	| gv group layout |
	gv := self createEmptyGraph.
	group := els asGroup.
	self addNodesTo: gv for: els.
	self addEdgesTo: gv for: group.
"	1halt.
	gv generator dotSourceWithLineFeedTerminators "
	"gv openInWindow."
	layout := XMLDOMParser parse: (gv asOutputType: 'svg').
	self applyLayout: (layout xPath: '//g[@class="node"]') to: group.
	self applyLayoutToEdges: (layout xPath: '//g[@class="edge"]')