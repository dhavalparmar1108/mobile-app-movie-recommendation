class MoviesList {
  List<String>? recommendedGenre;
  List<int>? recommendedId;
  List<String>? recommendedMovies;
  List<String>? recommendedOverview;
  List<String>? recommendedPosters;
  int? status;

  MoviesList(
      {this.recommendedGenre,
        this.recommendedId,
        this.recommendedMovies,
        this.recommendedOverview,
        this.recommendedPosters,
        this.status});

  MoviesList.fromJson(Map<String, dynamic> json) {
    recommendedGenre = json['recommended_genre'].cast<String>();
    recommendedId = json['recommended_id'].cast<int>();
    recommendedMovies = json['recommended_movies'].cast<String>();
    recommendedOverview = json['recommended_overview'].cast<String>();
    recommendedPosters = json['recommended_posters'].cast<String>();
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['recommended_genre'] = this.recommendedGenre;
    data['recommended_id'] = this.recommendedId;
    data['recommended_movies'] = this.recommendedMovies;
    data['recommended_overview'] = this.recommendedOverview;
    data['recommended_posters'] = this.recommendedPosters;
    data['status'] = this.status;
    return data;
  }
}
