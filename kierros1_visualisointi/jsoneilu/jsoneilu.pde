//tämä luokka luo testdata-kansion, sinne new.json tiedoston ja sen jälkeen se lukee siitä tietoja ja laittaa sitä ikkunaan pallon päälle 

JSONObject json;

void setup() {
  size(600,300);
  json = new JSONObject();

  json.setInt("id", 230);
  json.setInt("henkiloita", 45);
  json.setString("species", "Panthera leo");
  json.setString("name", "Lion");

  saveJSONObject(json, "testdata/new.json");
  
  int arvo = json.getInt("id");
  
  int halkaisija = json.getInt("henkiloita");
  fill(0);
  ellipse(arvo, 30, halkaisija, halkaisija); 
  fill(255);
  text(arvo, arvo, 30); 
  
  String nimi1 = json.getString("species");
  String nimi2 = json.getString("name");
  text(nimi1, arvo, 40); 
  text(nimi2, arvo, 50); 
}


