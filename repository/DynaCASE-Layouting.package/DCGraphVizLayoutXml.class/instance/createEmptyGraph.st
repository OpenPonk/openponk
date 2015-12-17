hook
createEmptyGraph
	| gv |
	(gv := GraphViz new)
		beDirected;
		add: #graph with: {(#splines -> #ortho)};
		add: #node
			with:
			{(#shape -> #box).
			(#fixedsize -> true)}.
	^ gv