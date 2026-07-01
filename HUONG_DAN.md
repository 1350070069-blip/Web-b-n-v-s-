# 📖 HƯỚNG DẪN CÀI ĐẶT & CHẠY DỰ ÁN QUẢN LÝ BÁN VÉ SỐ

## ⚙️ YÊU CẦU HỆ THỐNG
- Node.js >= 18.x (https://nodejs.org)
- MySQL >= 8.0 (https://dev.mysql.com/downloads/)
- VS Code (https://code.visualstudio.com)

---

## 📁 CẤU TRÚC THƯ MỤC

```
vesoproject/
├── config/
│   └── database.js          ← Kết nối MySQL
├── controllers/
│   ├── authController.js    ← Đăng nhập / đổi mật khẩu
│   ├── banVeController.js   ← Quản lý bán vé hàng ngày
│   ├── dashboardController.js ← Trang chủ / thống kê
│   ├── doanhThuController.js  ← Báo cáo doanh thu
│   └── tayEmController.js   ← Quản lý tay em / nghỉ phép
├── middleware/
│   └── auth.js              ← Xác thực phiên đăng nhập
├── public/
│   ├── css/style.css        ← CSS tùy chỉnh
│   └── js/main.js           ← JavaScript frontend
├── routes/
│   └── index.js             ← Tất cả routes
├── views/
│   ├── layouts/main.ejs     ← Layout chung
│   ├── pages/               ← Các trang
│   └── partials/            ← Sidebar, navbar
├── .env                     ← Cấu hình môi trường (QUAN TRỌNG)
├── database.sql             ← Script tạo CSDL
├── package.json
└── server.js                ← Entry point
```

---

## 🚀 BƯỚC 1: CÀI ĐẶT NODE.JS

1. Vào https://nodejs.org → tải bản **LTS**
2. Cài đặt theo hướng dẫn
3. Kiểm tra bằng lệnh:
   ```bash
   node --version   # phải >= 18.x
   npm --version
   ```

---

## 🐬 BƯỚC 2: CÀI VÀ CẤU HÌNH MYSQL

### Option A: MySQL Workbench (khuyên dùng)
1. Tải MySQL Installer: https://dev.mysql.com/downloads/installer/
2. Cài **MySQL Server + MySQL Workbench**
3. Trong quá trình cài, đặt **root password** (nhớ lại!)

### Option B: XAMPP (dễ hơn cho người mới)
1. Tải XAMPP: https://www.apachefriends.org
2. Cài đặt → mở **XAMPP Control Panel**
3. Bấm **Start** cho **MySQL**
4. Mặc định: user=`root`, password=`` (trống)

---

## 🗄️ BƯỚC 3: TẠO DATABASE

### Cách 1: Dùng MySQL Workbench
1. Mở MySQL Workbench → kết nối server
2. Menu **File → Open SQL Script** → chọn file `database.sql`
3. Bấm ⚡ (Execute) để chạy toàn bộ script
4. Refresh → thấy database `veso_db` là thành công ✅

### Cách 2: Dùng Command Line
```bash
# Đăng nhập MySQL
mysql -u root -p

# Chạy file SQL
SOURCE /đường/dẫn/đến/vesoproject/database.sql;

# Kiểm tra
SHOW DATABASES;
USE veso_db;
SHOW TABLES;
```

### Cách 3: Dùng phpMyAdmin (nếu dùng XAMPP)
1. Mở trình duyệt → vào `http://localhost/phpmyadmin`
2. Tab **Import** → chọn file `database.sql` → bấm **Go**

---

## ⚙️ BƯỚC 4: CẤU HÌNH FILE .env

Mở file `.env` trong VS Code và chỉnh sửa:

```env
PORT=3000
NODE_ENV=development

# Đổi thông tin kết nối MySQL của bạn
DB_HOST=localhost
DB_PORT=3306
DB_USER=root
DB_PASSWORD=mật_khẩu_mysql_của_bạn   ← THAY ĐỔI DÒNG NÀY
DB_NAME=veso_db

SESSION_SECRET=veso_secret_key_2024_abc_xyz   ← Đổi thành chuỗi ngẫu nhiên
APP_NAME=Quản Lý Bán Vé Số
```

> ⚠️ Nếu dùng XAMPP, `DB_PASSWORD` thường để **trống** (xóa hết, không gõ gì)

---

## 📦 BƯỚC 5: CÀI THƯ VIỆN NODE.JS

Mở **Terminal trong VS Code** (Ctrl + `` ` ``):

```bash
# Di chuyển vào thư mục project
cd đường/dẫn/đến/vesoproject

# Cài thêm EJS (view engine) và các thư viện
npm install

# Cài thêm EJS (chưa có trong package.json)
npm install ejs

# Cài nodemon để tự động restart khi sửa code (dev)
npm install -D nodemon
```

---

## ▶️ BƯỚC 6: CHẠY DỰ ÁN

```bash
# Chạy bình thường
npm start

# Hoặc chạy dev mode (tự restart khi sửa file)
npm run dev
```

Thấy thông báo:
```
✅ Kết nối MySQL thành công!
Server đang chạy: http://localhost:3000
```

Mở trình duyệt vào: **http://localhost:3000**

---

## 🔐 ĐĂNG NHẬP LẦN ĐẦU

- **Tên đăng nhập:** `admin`
- **Mật khẩu:** `Admin@123`

> ⚠️ Đổi mật khẩu ngay sau khi đăng nhập lần đầu!

---

## 🛠️ VS CODE EXTENSIONS NÊN CÀI

1. **EJS Language Support** - highlight syntax file .ejs
2. **MySQL** (by cweijan) - quản lý DB ngay trong VS Code
3. **Thunder Client** - test API
4. **Prettier** - format code
5. **Auto Rename Tag** - sửa HTML tag nhanh

Cài trong VS Code: Ctrl+Shift+X → tìm tên extension → Install

---

## ❌ XỬ LÝ LỖI THƯỜNG GẶP

| Lỗi | Nguyên nhân | Cách sửa |
|-----|-------------|----------|
| `ECONNREFUSED` | MySQL chưa chạy | Khởi động MySQL / XAMPP |
| `ER_ACCESS_DENIED_ERROR` | Sai user/password | Kiểm tra file .env |
| `ER_BAD_DB_ERROR` | Chưa tạo database | Chạy file database.sql |
| `Cannot find module 'ejs'` | Chưa cài ejs | `npm install ejs` |
| `Port 3000 in use` | Cổng đã bị dùng | Đổi PORT trong .env |
| `connect ETIMEDOUT` | Sai DB_HOST | Kiểm tra host trong .env |

---

## 📝 GHI CHÚ QUAN TRỌNG

- File `.env` **KHÔNG** được đưa lên Git (đã có trong .gitignore)
- Password trong database được mã hóa bằng **bcrypt** (an toàn)
- Session tự hết hạn sau **8 giờ**
- Mọi thao tác xóa đều yêu cầu quyền **admin**
