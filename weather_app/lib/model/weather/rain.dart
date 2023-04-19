class Rain {
	double? oneHour;

	Rain({this.oneHour});

	factory Rain.fromJson(Map<String, dynamic> json) => Rain(
				oneHour: (json['1h'] as num?)?.toDouble(),
			);

	Map<String, dynamic> toJson() => {
				'1h': oneHour,
			};
}
