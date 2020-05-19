class GeoModel {
    int fid;
    String gmid;
    String dataset;
    String facilityName;
    String address;
    String datasetZh;
    String facilityNameZh;
    int telephone;
    String website;
    int northing;
    int easting;
    double latitude;
    double longitude;

    GeoModel({
        this.fid,
        this.gmid,
        this.dataset,
        this.facilityName,
        this.address,
        this.datasetZh,
        this.facilityNameZh,
        this.telephone,
        this.website,
        this.northing,
        this.easting,
        this.latitude,
        this.longitude,
    });
    factory GeoModel.fromJson(Map<String, dynamic> json) {
    return GeoModel(
      fid: json["FID"],
        gmid: json["GMID"],
        dataset: json["Dataset"],
        facilityName: json["Facility_Name"],
        address: json["Address"],
        datasetZh: json["Dataset_zh"],
        facilityNameZh: json["Facility_Name_zh"],
        telephone: json["Telephone"],
        website: json["Website"],
        northing: json["Northing"],
        easting: json["Easting"],
        latitude: json["Latitude"].toDouble(),
        longitude: json["Longitude"].toDouble(),
    );
    }
}