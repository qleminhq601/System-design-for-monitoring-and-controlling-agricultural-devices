🌱 Smart Agriculture System – Giám Sát & Điều Khiển Thiết Bị Trồng Trọt

📌Giới thiệu

Dự án này triển khai một hệ thống IoT nhằm giám sát và điều khiển thiết bị trong nông nghiệp, giúp thu thập các thông số môi trường và điều khiển thiết bị tưới tiêu thông minh. Hệ thống kết nối ESP32, cảm biến môi trường, Firebase, và ứng dụng điện thoại Flutter để cung cấp một giải pháp canh tác hiệu quả và tiện lợi.

----------------------------------------------------------------------------------------------
🎯Mục tiêu
- Thu thập nhiệt độ, độ ẩm không khí, độ ẩm đất, cường độ ánh sáng, mực nước, và dòng điện.
- Hiển thị dữ liệu thực tế qua LCD 1602 và ứng dụng điện thoại.
- Điều khiển từ xa máy bơm nước và đèn LED bằng ứng dụng hoặc tự động hóa dựa trên độ ẩm.
- Lưu trữ & đồng bộ dữ liệu theo thời gian thực với Google Firebase.

-----------------------------------------------------------------------------------------------
🧩Kiến trúc hệ thống
  
![image](https://github.com/user-attachments/assets/92999f5d-24a3-407f-9309-a13fbb1f93af)

-----------------------------------------------------------------------------------------------
🧰Phần cứng sử dụng

ESP32, DHT11, SMS-V1, LM393, HY-SRF05, ACS712, LCD 1602 + I2C, L298N, Bơm nước mini.

-----------------------------------------------------------------------------------------------
💻Phần mềm sử dụng
Arduino IDE: Lập trình cho ESP32.

Firebase Realtime Database: Lưu trữ và đồng bộ dữ liệu cảm biến.

Flutter + Android Studio: Phát triển ứng dụng giám sát từ xa.

Altium Designer: Thiết kế sơ đồ nguyên lý và bo mạch PCB.

----------------------------------------------------------------------------------------------
Hỉnh ảnh sản phẩm 

Phần cứng

![image](https://github.com/user-attachments/assets/721568d6-7570-4d5f-9683-6a14af82ada1)

![image](https://github.com/user-attachments/assets/2783a23b-533d-40a4-b210-cafa13dbcdef)

![image](https://github.com/user-attachments/assets/c2f4e9ac-8d0c-4cb6-ac4b-f674cf4df12a)

Phần mềm

![image](https://github.com/user-attachments/assets/c4e7867f-88ae-49c4-b8ef-ddfa569d97dc) 

![image](https://github.com/user-attachments/assets/91793ffb-588d-466a-b1a0-1c5c239c2292)

----------------------------------------------------------------------------------------------
⚙️ Cách triển khai
1. Thư mục "Code_doan" chứa file code nạp cho ESP32
2. Thư mục "dart của app" là code cho app điện thoại, có thể dùng VS Code để mở
3. Bản vẽ PCB ở trong "PCB_project"

----------------------------------------------------------------------------------------------
✍️ Tác giả
Lê Minh Quang - 21139045

Hà Văn Trung  - 21139065
