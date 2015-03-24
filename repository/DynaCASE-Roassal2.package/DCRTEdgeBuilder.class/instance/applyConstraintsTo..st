private
applyConstraintsTo: anEdge
	constraints do: [ :constraint | constraint cull: anEdge ]