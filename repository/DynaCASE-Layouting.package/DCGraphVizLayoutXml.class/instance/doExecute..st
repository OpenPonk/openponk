hook
doExecute: els
	| gv group layout |
	gv := self createEmptyGraph.
	group := els asGroup.
	self addNodesTo: gv for: els.
	self addEdgesTo: gv for: group.
	"1halt."
	"gv openInWindow."
	layout := gv asXml.
	self applyLayout: layout // #node to: group.
	self applyLayoutToEdges: layout // #edge