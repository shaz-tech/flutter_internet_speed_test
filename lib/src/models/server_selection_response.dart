class ServerSelectionResponse {
  Client? _client;
  List<Targets>? _targets;

  ServerSelectionResponse({Client? client, List<Targets>? targets}) {
    if (client != null) {
      _client = client;
    }
    if (targets != null) {
      _targets = targets;
    }
  }

  Client? get client => _client;

  set client(Client? client) => _client = client;

  List<Targets>? get targets => _targets;

  set targets(List<Targets>? targets) => _targets = targets;

  ServerSelectionResponse.fromJson(Map<String, dynamic> json) {
    _client = json['client'] != null ? Client.fromJson(json['client']) : null;
    if (json['targets'] != null) {
      _targets = <Targets>[];
      json['targets'].forEach((v) {
        _targets!.add(Targets.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (_client != null) {
      data['client'] = _client!.toJson();
    }
    if (_targets != null) {
      data['targets'] = _targets!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Client {
  String? _ip;
  String? _asn;
  String? _isp;
  Location? _location;

  Client({String? ip, String? asn, String? isp, Location? location}) {
    if (ip != null) {
      _ip = ip;
    }
    if (asn != null) {
      _asn = asn;
    }
    if (isp != null) {
      _isp = isp;
    }
    if (location != null) {
      _location = location;
    }
  }

  String? get ip => _ip;

  set ip(String? ip) => _ip = ip;

  String? get asn => _asn;

  set asn(String? asn) => _asn = asn;

  String? get isp => _isp;

  set isp(String? isp) => _isp = isp;

  Location? get location => _location;

  set location(Location? location) => _location = location;

  Client.fromJson(Map<String, dynamic> json) {
    _ip = json['ip'];
    _asn = json['asn'];
    _isp = json['isp'];
    _location =
        json['location'] != null ? Location.fromJson(json['location']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['ip'] = _ip;
    data['asn'] = _asn;
    data['isp'] = _isp;
    if (_location != null) {
      data['location'] = _location!.toJson();
    }
    return data;
  }
}

class Location {
  String? _city;
  String? _country;

  Location({String? city, String? country}) {
    if (city != null) {
      _city = city;
    }
    if (country != null) {
      _country = country;
    }
  }

  String? get city => _city;

  set city(String? city) => _city = city;

  String? get country => _country;

  set country(String? country) => _country = country;

  Location.fromJson(Map<String, dynamic> json) {
    _city = json['city'];
    _country = json['country'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['city'] = _city;
    data['country'] = _country;
    return data;
  }
}

class Targets {
  String? _name;
  String? _url;
  Location? _location;

  Targets({String? name, String? url, Location? location}) {
    if (name != null) {
      _name = name;
    }
    if (url != null) {
      _url = url;
    }
    if (location != null) {
      _location = location;
    }
  }

  String? get name => _name;

  set name(String? name) => _name = name;

  String? get url => _url;

  set url(String? url) => _url = url;

  Location? get location => _location;

  set location(Location? location) => _location = location;

  Targets.fromJson(Map<String, dynamic> json) {
    _name = json['name'];
    _url = json['url'];
    _location =
        json['location'] != null ? Location.fromJson(json['location']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = _name;
    data['url'] = _url;
    if (_location != null) {
      data['location'] = _location!.toJson();
    }
    return data;
  }
}
