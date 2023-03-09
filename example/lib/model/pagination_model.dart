class AnimePaginatedList {
  Pagination? pagination;
  List<Anime>? animeList;

  AnimePaginatedList({this.pagination, this.animeList});

  AnimePaginatedList.fromJson(Map<String, dynamic> json) {
    pagination = json['pagination'] != null
        ? Pagination.fromJson(json['pagination'])
        : null;
    if (json['data'] != null) {
      animeList = <Anime>[];
      json['data'].forEach((v) {
        animeList!.add(Anime.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (pagination != null) {
      data['pagination'] = pagination!.toJson();
    }
    if (animeList != null) {
      data['data'] = animeList!.map((v) => v.toJson()).toList();
    }
    return data;
  }

  fromJson(Map<String, dynamic> json) => AnimePaginatedList.fromJson(json);
}

class Pagination {
  int? lastVisiblePage;
  bool? hasNextPage;
  int? currentPage;
  Items? items;

  Pagination(
      {this.lastVisiblePage, this.hasNextPage, this.currentPage, this.items});

  Pagination.fromJson(Map<String, dynamic> json) {
    lastVisiblePage = json['last_visible_page'];
    hasNextPage = json['has_next_page'];
    currentPage = json['current_page'];
    items = json['items'] != null ? Items.fromJson(json['items']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['last_visible_page'] = lastVisiblePage;
    data['has_next_page'] = hasNextPage;
    data['current_page'] = currentPage;
    if (items != null) {
      data['items'] = items!.toJson();
    }
    return data;
  }
}

class Items {
  int? count;
  int? total;
  int? perPage;

  Items({this.count, this.total, this.perPage});

  Items.fromJson(Map<String, dynamic> json) {
    count = json['count'];
    total = json['total'];
    perPage = json['per_page'];
  }

  Future<Map<String, dynamic>> toJson() async {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['count'] = count;
    data['total'] = total;
    data['per_page'] = perPage;
    return data;
  }
}

class Anime {
  int? malId;
  String? title;

  Anime({
    this.malId,
    this.title,
  });

  Anime.fromJson(Map<String, dynamic> json) {
    malId = json['mal_id'];
    title = json['title'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['mal_id'] = malId;
    data['title'] = title;
    return data;
  }

  fromJson(Map<String, dynamic> json) => Anime.fromJson(json);
}
