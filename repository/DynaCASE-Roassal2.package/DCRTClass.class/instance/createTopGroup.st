private
createTopGroup
	topGroup := RTGroup new.
	topGroup
		add:
				(RTLabel new
						height: 8;
						elementOn: (self stereotypeFor: stereotype value));
		add:
				(RTLabel new
						height: 12;
						elementOn: name value).
	^ topGroup