private
buttonMorph: aModel
	^ (super buttonMorph: aModel)
		icon: aModel glamourAction icon;
		label: aModel buttonLabel;
		yourself