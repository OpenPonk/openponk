private
createTopGroup
	topGroup := RTGroup new.
	topGroup
		add:
				(RTLabel new
						height: 8;
						color: Color black;
						elementOn: (self stereotypeFor: stereotype value));
		add:
				(RTLabel new
						height: 12;
						color: Color black;
						elementOn: name value).
	^ topGroup