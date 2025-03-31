#include "DHT.h"
#include <Wire.h>
#include <LiquidCrystal_I2C.h>
#include <WiFi.h>
#include "FirebaseESP32.h"
#include <addons/RTDBHelper.h>
#include <addons/TokenHelper.h>

#define Buzzer 25 

const char* ssid     = "milu-misa";
const char* password = "19551963luna";

#define DHT_PIN 18
#define DHTTYPE DHT11 
DHT dht(DHT_PIN, DHTTYPE);  

#define CB_AM 35
#define Water_Pump 26 //Chân Input 3-
#define Water_Punp2 27 //Chân Input 4
int motorSpeed = 0;
int speedIncrement = 10;

#define CB_AS 34
#define led 14

#define trig  33
#define echo 5

#define ledtest 23

#define ACS_OUT 32

LiquidCrystal_I2C lcd(0x27,16,2);

int Amdat;
int Realpercent;
int percent;

float f,t;
float h;

unsigned long duration; // biến đo thời gian
int distance;           // biến lưu khoảng cách

int flag;
int anhsang;

float current;

//float AcsValue=0.0, Samples=0.0, AvgAcs=0.0, AcsValueF=0.0;

#define API_KEY "AIzaSyAvDQXjXzpyjv2S_e87REcgaCmYs4eiF9w"
#define DATABASE_URL "https://doan1-df431-default-rtdb.firebaseio.com/" //<databaseName>.firebaseio.com or <databaseName>.<region>.firebasedatabase.app
#define USER_EMAIL "quangquangne2003@gmail.com"
#define USER_PASSWORD "123456" //mk đăng kí cho gmail trên FireBase chứ k pải mk gmail
FirebaseData fbdo;
FirebaseAuth auth;
FirebaseData stream;
FirebaseConfig config;
unsigned long sendDataPrevMillis = 0;
unsigned long count = 0;

int ledState = 0;

int motorState=0;
int chedoState;

int Nguongbat;
int Nguongtat;


void setup() {
  //Chạy Serial và 
  //hiển thị kết nối WIFI thành công trên LCD
  lcd.init();
  lcd.backlight();
  lcd.setCursor(0,0);
  delay(500);
  lcd.clear();
  //kết nối WIFI
  Serial.begin(9600);
  WiFi.begin(ssid, password);
  Serial.print("Connecting to Wi-Fi");
  while (WiFi.status() != WL_CONNECTED){
    Serial.print(".");
    delay(300);
  }
  Serial.println();
  Serial.print("Connected with IP: ");
  Serial.println(WiFi.localIP());
  Serial.println("Kết nối thành công với WIFI: ");
  lcd.print("Wifi Connected");
  Serial.println(ssid);
  Serial.println();
  

  // Firebase setup
  Serial.printf("Firebase Client v%s\n\n", FIREBASE_CLIENT_VERSION);
  config.api_key = API_KEY;
  auth.user.email = USER_EMAIL;
  auth.user.password = USER_PASSWORD;
  config.database_url = DATABASE_URL;
  config.token_status_callback = tokenStatusCallback; // see addons/TokenHelper.h
  Firebase.reconnectNetwork(true);
  // Since v4.4.x, BearSSL engine was used, the SSL buffer need to be set.
  // Large data transmission may require larger RX buffer, otherwise connection issue or data read time out can be occurred.
  fbdo.setBSSLBufferSize(4096 /* Rx buffer size in bytes from 512 - 16384 */, 1024 /* Tx buffer size in bytes from 512 - 16384 */);
  Firebase.begin(&config, &auth);
  Firebase.setDoubleDigits(5);
  

  dht.begin();


  pinMode(CB_AM, INPUT);
  pinMode(Water_Pump, OUTPUT);
  pinMode(Water_Punp2,OUTPUT);
  digitalWrite(Water_Pump, LOW);
  digitalWrite(Water_Punp2, LOW);


  pinMode(CB_AS, INPUT);
  pinMode(led,OUTPUT);


  pinMode(trig,OUTPUT);   // chân trig sẽ phát tín hiệu
  pinMode(echo,INPUT);    // chân echo sẽ nhận tín hiệu


  pinMode(Buzzer,OUTPUT);

  
  pinMode(ledtest, OUTPUT);

  pinMode(ACS_OUT, INPUT);
}


void loop() {
  /* Phát xung từ chân trig */
  digitalWrite(trig,0);   // tắt chân trig
  delayMicroseconds(2);
  digitalWrite(trig,1);
  delayMicroseconds(10);
  digitalWrite(trig,0);
  duration = pulseIn(echo, HIGH);
  distance = int(duration/29/2);
  if(duration==0){
    Serial.println("Warning: no pulse from sensor");
  }  
  else{
    Serial.print("distance to nearest object: ");
    Serial.print(distance);
    Serial.println(" cm");
    Serial.print("Muc nuoc: ");
    Serial.print(15-distance);
    Serial.println(" cm");
  }
  delay(100);
  if((15-distance) <= 4) //Mực nước tối đa là 16cm
  {
    digitalWrite(Buzzer, HIGH);
  }else {
    digitalWrite(Buzzer, LOW);
  }

  
  percent = analogRead(CB_AM); 
  Realpercent = map(percent,0,4095,0,100); //gia tri đo độ khô, 4095: khoảng ADC của ESP32, của Adruino là 1023
  Amdat = 100 - Realpercent;               //Amdat = 100 - độ khô  
  Serial.print("Soil Moisture: ");
  Serial.print(Amdat);
  Serial.println('%');

  
  anhsang = analogRead(CB_AS);
  Serial.print("Light Intensity: ");
  Serial.print(anhsang);
  Serial.println("cd");
  
  
  delay(1000);
  // Reading temperature or humidity takes about 250 milliseconds!
  // Sensor readings may also be up to 2 seconds 'old' (its a very slow sensor)
  h = dht.readHumidity();
  // Read temperature as Celsius (the default)
  t = dht.readTemperature();
  // Read temperature as Fahrenheit (isFahrenheit = true)
  f = dht.readTemperature(true);
  // Check if any reads failed and exit early (to try again).
  if (isnan(h) || isnan(t) || isnan(f)) {
    Serial.println("Failed to read from DHT sensor!");
    return;
  }
  // Compute heat index in Fahrenheit (the default)
  float hif = dht.computeHeatIndex(f, h);
  // Compute heat index in Celsius (isFahreheit = false)
  float hic = dht.computeHeatIndex(t, h, false);
  
  
  display();


  Serial.print("Humidity: ");
  Serial.print(h);
  Serial.println("%");
  Serial.print("Temperature: ");
  Serial.print(t);
  Serial.print("°C ");
  Serial.print(f);
  Serial.println("°F");
  Serial.print("Heat index: ");
  Serial.print(hic);
  Serial.print("°C ");
  Serial.print(hif);
  Serial.println("°F");
  Serial.println("------------------");
  
  
  uploadFirebase();
  ControlDeviceLight();
  ControlDeviceMotor(); 
}

void ACS_Current(){
  float R1 = 5000.0;
  float R2 = 10000.0;
    int adc = analogRead(ACS_OUT);
    float adc_voltage = adc * (3.3 / 4096.0);
    float current_voltage = (adc_voltage * (R1+R2)/R2);
    current = (current_voltage - 2.5) / 0.100;
    Serial.print("Current Value: ");
    Serial.println(current);
    delay(1000);                      
}

void uploadFirebase(){
  if (Firebase.ready() && (millis() - sendDataPrevMillis > 1000 || sendDataPrevMillis == 0))
  {
    sendDataPrevMillis = millis();
    Firebase.set(fbdo,"Do am", h);
    Firebase.set(fbdo, "Nhiet do", t);
    Firebase.set(fbdo,"Do am dat", Amdat);
    Firebase.set(fbdo,"Anhsang",anhsang);
    Firebase.set(fbdo,"Muc nuoc",15 - distance);
    Firebase.set(fbdo,"Dong dien",current);
  }
}

void display(){
  lcd.setCursor(0,0);
  lcd.print("Tp:");
  lcd.print(t);

  lcd.setCursor(9,0);
  lcd.print("Hu:");
  lcd.print(h);

  lcd.setCursor(0,1);
  lcd.print("SHu:");
  lcd.print(Amdat);

  lcd.setCursor(8,1);
  lcd.print("LV:");
  lcd.print(15-distance);
  lcd.print("cm");
}

void motor_speed(){
    for (motorSpeed = 0; motorSpeed <= 55; motorSpeed += speedIncrement) {
    digitalWrite(Water_Pump,HIGH);
    analogWrite(Water_Punp2,motorSpeed);
    ACS_Current();
    delay(2000); // Đợi một giây trước khi tăng tốc độ tiếp theo
  }
    for (motorSpeed = 55; motorSpeed >= 0; motorSpeed -= speedIncrement) {
    digitalWrite(Water_Pump,LOW);
    analogWrite(Water_Punp2,motorSpeed);
    ACS_Current();
    delay(2000); // Đợi một giây trước khi giảm tốc độ tiếp theo
  }
}

void ControlDeviceLight(){
  if(Firebase.getInt(fbdo, "/den", &ledState)){
    if(ledState == 0){
      digitalWrite(led, ledState);
    }
    if(ledState == 1){
      digitalWrite(led, ledState);
    }
  }
  else{
    Serial.println(fbdo.errorReason().c_str());
  }
}

void ControlDeviceMotor(){
  if(Firebase.getInt(fbdo, "chedo", &chedoState)){
    if(chedoState == 0){
      if(Firebase.getInt(fbdo, "bom", &motorState)){
        if(motorState == 1){
          digitalWrite(Water_Pump, HIGH);
          digitalWrite(Water_Punp2, LOW);
          ACS_Current();
          digitalWrite(ledtest, HIGH);          
        }
        else if(motorState == 0){
          digitalWrite(Water_Pump, LOW);
          digitalWrite(ledtest, LOW);
          ACS_Current();
        }
      }
      else{
       Serial.println(fbdo.errorReason().c_str());
      }
    }
    
    if(chedoState == 1){
      if(Firebase.getInt(fbdo,"z_Doam_bat_bom",&Nguongbat) && Firebase.getInt(fbdo,"z_Doam_tat_bom",&Nguongtat)){
        if (Amdat <= Nguongbat){ 
          while (Amdat <= Nguongtat){
            motor_speed();
            delay(1000);
          }
        }
      }
      else{
        Serial.println(fbdo.errorReason().c_str());
      }
    }
  }
  else{
    Serial.println(fbdo.errorReason().c_str());
  }
} 
         
          


