🛡️ ARISE! Progress Report (01/04/2026)
All Update UI Page Completed
- Login
- Register
- Dashboard
- Profile
- Setting
- Select quest page
- Calibration
- Mock data
- Rest page
- Completed page

DataService
- มี SharedPreferences เก็บสถานะภารกิจรายวัน (Quest Status) และการตั้งค่าในเครื่อง
- มี Firebase Firestore เก็บข้อมูลโปรไฟล์ และคะแนน EXP สะสมรวมของกล้ามเนื้อ 5 ส่วน (Chest, Shoulder, Biceps, Abs, Legs)

Logic workout flow
- สร้าง Flow การออกกำลังกาย: Select Quest >> Calibration >> Mock Data >> Rest
- ระบบเช็กเงื่อนไขการทำครบทุกท่า: เมื่อครบ 3 ท่าจะส่งไปหน้า Completed อัตโนมัติ
- ปรับปรุง Navigation: แก้ปัญหาหน้าจอมืด (Black Screen) โดยการใช้ popUntil กลับสู่หน้าแรกสุด

ฟีเจอร์หน้า Profile & Dashboard
- เลือกรูปโปรไฟล์จาก Gallery ในเครื่องได้
- แสดงชื่อผู้เล่นตรง card ในหน้า Dashboard (พร้อมคำนำหน้า Hunter)
- ดึงข้อมูลส่วนตัวมาแสดงและแก้ไขได้ (น้ำหนัก, ส่วนสูง, เพศ)

งานในอนาคต
- Camera UI
- Ai Pose Detection (ML Kit)
- Counting Reps with Ai