class MoviesList {
  Recommendations? recommendations;

  MoviesList({this.recommendations});

  MoviesList.fromJson(Map<String, dynamic> json) {
    recommendations = json['recommendations'] != null
        ? new Recommendations.fromJson(json['recommendations'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.recommendations != null) {
      data['recommendations'] = this.recommendations!.toJson();
    }
    return data;
  }
}

class Recommendations {
  List<String>? recommendedGenre;
  List<int>? recommendedId;
  List<String>? recommendedMovies;
  List<String>? recommendedOverview;
  List<String>? recommendedPosters;

  Recommendations(
      {this.recommendedGenre,
        this.recommendedId,
        this.recommendedMovies,
        this.recommendedOverview,
        this.recommendedPosters});

  Recommendations.fromJson(Map<String, dynamic> json) {
    recommendedGenre = json['recommended_genre'].cast<String>();
    recommendedId = json['recommended_id'].cast<int>();
    recommendedMovies = json['recommended_movies'].cast<String>();
    recommendedOverview = json['recommended_overview'].cast<String>();
    recommendedPosters = json['recommended_posters'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['recommended_genre'] = this.recommendedGenre;
    data['recommended_id'] = this.recommendedId;
    data['recommended_movies'] = this.recommendedMovies;
    data['recommended_overview'] = this.recommendedOverview;
    data['recommended_posters'] = this.recommendedPosters;
    return data;
  }
}
