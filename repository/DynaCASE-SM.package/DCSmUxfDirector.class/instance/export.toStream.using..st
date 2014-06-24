as yet unclassified
export: aLayout toStream: aStream using: aBuilder
	| vertices transitions |
	vertices := aLayout select: [ :item | item model isKindOf: DCSmVertex ].
	transitions := aLayout select: [ :item | item model isKindOf: DCSmTransition ].
	aBuilder reset.
	aBuilder buildHeader.
	vertices do: [ :item | aBuilder buildVertex: item ].
	transitions do: [ :item | aBuilder buildTransition: item ]