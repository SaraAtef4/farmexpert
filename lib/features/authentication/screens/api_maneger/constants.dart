class ApiConstants {
  static const String baseUrl = 'https://farmxpertapi.runasp.net/api';

  // Auth
  static const String login = '$baseUrl/Auth/login';

  // Worker
  static const String addWorker = '$baseUrl/Worker/AddWorker';
  static const String getAllWorkers = '$baseUrl/Worker/all';
  static const String deleteWorker = '$baseUrl/Worker/delete'; // + /:id
  static const String updateWorker = '$baseUrl/Worker/UpdateWorker'; // + /:id

  // Veterinarians
  static const String addVeterinair = '$baseUrl/Veterinarians/AddVeterinar';
  static const String getAllVeterinairs = '$baseUrl/Veterinarians/all';
  static const String updateVeterinair = '$baseUrl/Veterinarians/UpdateVeterinar'; // + /:id
  static const String deleteVeterinair = '$baseUrl/Veterinarians/delete'; // + /:id


  // Cattle
  static const String getCattlesByType = '$baseUrl/Cattle/GetCattlesByType'; // + /:type
  static const String getCattleByTypeAndId = '$baseUrl/Cattle/GetCattleByTypeAndId'; // + /:type/:id
  static const String addCattle = '$baseUrl/Cattle/AddCattle';
  static const String updateCattle = '$baseUrl/Cattle/UpdateCattle'; // + /:id
  static const String deleteCattle = '$baseUrl/Cattle/DeleteCattle'; // + /:id

  // Milk Production
  static const String milkProduction = '$baseUrl/MilkProduction';
  static const String addMilk = '$milkProduction/Add';
  static const String addMilkMultiple = '$milkProduction/AddMultiple';
  static const String getAllMilk = '$milkProduction/All';
  static const String getFemaleCows = '$milkProduction/GetCattlesByTypeAndGender?type=Cow&gender=Female';
  static const String deleteMilkProduction = '$milkProduction/Delete';
  static const String editMilkProduction = '$milkProduction/edit';

  //cattle acticity

  static const String cattleActivityIND_EventTypes = '$baseUrl/CattleActivityIND/EventTypes';
  static const String cattleActivityIND_AddEvent = '$baseUrl/CattleActivityIND/AddEvent';


}
