class ServerSelectionResponse {
  late final Client? client;
  late final List<Targets>? targets;

  ServerSelectionResponse({this.client, this.targets});

  ServerSelectionResponse.fromJson(Map<String, dynamic> json) {
    client = json['client'] != null ? Client.fromJson(json['client']) : null;
    targets = <Targets>[];
    if (json['targets'] != null) {
      json['targets'].forEach((v) {
        targets!.add(Targets.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (client != null) {
      data['client'] = client!.toJson();
    }
    if (targets != null) {
      data['targets'] = targets!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Client {
  late final String? ip;
  late final String? asn;
  late final String? isp;
  late final Location? location;

  Client({this.ip, this.asn, this.isp, this.location});

  Client.fromJson(Map<String, dynamic> json) {
    ip = json['ip'];
    asn = json['asn'];
    isp = json['isp'];
    location =
        json['location'] != null ? Location.fromJson(json['location']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['ip'] = ip;
    data['asn'] = asn;
    data['isp'] = isp;
    if (location != null) {
      data['location'] = location!.toJson();
    }
    return data;
  }
}

class Location {
  late final String? city;
  late final String? country;

  Location({this.city, this.country});

  Location.fromJson(Map<String, dynamic> json) {
    city = json['city'];
    country = json['country'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['city'] = city;
    data['country'] = country;
    return data;
  }
}

class Targets {
  late final String? name;
  late final String? url;
  late final Location? location;

  Targets.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    url = json['url'];
    location =
        json['location'] != null ? Location.fromJson(json['location']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['url'] = url;
    if (location != null) {
      data['location'] = location!.toJson();
    }
    return data;
  }
}
