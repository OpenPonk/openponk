labels
constraintLabel: labelName onTheRightOf: originLabelName
	| label originLabel |
	label := self labelNamed: labelName.
	originLabel := self labelNamed: originLabelName.
	constraints add: [ TRConstraint stick: label onTheRightOf: originLabel ]