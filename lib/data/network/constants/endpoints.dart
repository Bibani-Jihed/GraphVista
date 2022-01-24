class Endpoints {
  // to make the class non-instantiable
  Endpoints._();

  // base url
  static const String BASE_URL = "https://petsweight.herokuapp.com/";

  //ID
  static const String PET_ID = "61eaadcd6e30b45bf4cc6a50";

  // headers
  static const Map<String, String> HEADERS = {
    'accept': 'application/json; charset=UTF-8',
    'Content-Type': 'application/json',
  };

// booking endpoints
  static const String PETS = BASE_URL + "pets";
}
