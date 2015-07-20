labels
constraintLabel: labelName below: originLabelName
	| label originLabel |
	label := self labelNamed: labelName.
	originLabel := self labelNamed: originLabelName.
	constraints add: [ DCTRConstraint stick: label below: originLabel ]