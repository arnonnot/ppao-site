# PPAO Static Site

โครงสร้างสำหรับโฮสต์หน้าเว็บบน **GitHub Pages** และฝังใน **Glide**

## โครง
- เสิร์ฟจากโฟลเดอร์ `pages/` (ปรับใน workflow ได้)
- หน้า Landing: `/pages/index.html`
- หน้า HR/โครงการทดสอบ: `/pages/hr/khrxngkar-thdsxb/index.html`
- ทรัพยากรส่วนกลาง: `/assets/...`

## Deploy
1. สร้าง repo ชื่อ `ppao-site` (หรือชื่อที่ต้องการ)
2. อัปโหลดไฟล์ทั้งหมดนี้ขึ้น branch `main`
3. เปิด GitHub Pages: Settings → Pages → Deploy from GitHub Actions
4. ไฟล์ workflow `.github/workflows/pages.yml` จะดีพลอยอัตโนมัติเมื่อ push เข้าสู่ `main`

## ใช้ใน Glide
- ใส่ URL: `https://<username>.github.io/pages/hr/khrxngkar-thdsxb/` ใน Web View
- ถ้าต้องการ Desktop view ตลอด: meta viewport ถูกตั้งไว้ที่ `width=1200` แล้ว

## หมายเหตุ
- ไฟล์หน้านี้ได้มาจากการบันทึก SingleFile จาก Google Sites และถูกแก้ meta viewport เพื่อบังคับ Desktop view
- หากมีหน้าใหม่ ให้คัดลอกโครงโฟลเดอร์ภายใต้ `pages/` และเพิ่มลิงก์ใน `pages/index.html` พร้อมอัปเดต `sitemap.xml`
