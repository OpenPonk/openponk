labels
constraintLabel: labelName below: originLabelName
	| label originLabel |
	label := self labelNamed: labelName.
	originLabel := self labelNamed: originLabelName.
	constraints add: [ TRConstraint stick: label below: originLabel ]