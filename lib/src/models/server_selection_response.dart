class ServerSelectionResponse {
  Client? _client;
  List<Targets>? _targets;

  ServerSelectionResponse({Client? client, List<Targets>? targets}) {
    if (client != null) {
      this._client = client;
    }
    if (targets != null) {
      this._targets = targets;
    }
  }

  Client? get client => _client;

  set client(Client? client) => _client = client;

  List<Targets>? get targets => _targets;

  set targets(List<Targets>? targets) => _targets = targets;

  ServerSelectionResponse.fromJson(Map<String, dynamic> json) {
    _client =
        json['client'] != null ? new Client.fromJson(json['client']) : null;
    if (json['targets'] != null) {
      _targets = <Targets>[];
      json['targets'].forEach((v) {
        _targets!.add(new Targets.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this._client != null) {
      data['client'] = this._client!.toJson();
    }
    if (this._targets != null) {
      data['targets'] = this._targets!.map((v) => v.toJson()).toList();
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
      this._ip = ip;
    }
    if (asn != null) {
      this._asn = asn;
    }
    if (isp != null) {
      this._isp = isp;
    }
    if (location != null) {
      this._location = location;
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
    _location = json['location'] != null
        ? new Location.fromJson(json['location'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ip'] = this._ip;
    data['asn'] = this._asn;
    data['isp'] = this._isp;
    if (this._location != null) {
      data['location'] = this._location!.toJson();
    }
    return data;
  }
}

class Location {
  String? _city;
  String? _country;

  Location({String? city, String? country}) {
    if (city != null) {
      this._city = city;
    }
    if (country != null) {
      this._country = country;
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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['city'] = this._city;
    data['country'] = this._country;
    return data;
  }
}

class Targets {
  String? _name;
  String? _url;
  Location? _location;

  Targets({String? name, String? url, Location? location}) {
    if (name != null) {
      this._name = name;
    }
    if (url != null) {
      this._url = url;
    }
    if (location != null) {
      this._location = location;
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
    _location = json['location'] != null
        ? new Location.fromJson(json['location'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this._name;
    data['url'] = this._url;
    if (this._location != null) {
      data['location'] = this._location!.toJson();
    }
    return data;
  }
}
