-- ============================================================
-- HỆ THỐNG QUẢN LÝ BÁN VÉ SỐ
-- Database: veso_db
-- ============================================================

CREATE DATABASE IF NOT EXISTS veso_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE veso_db;

-- ============================================================
-- BẢNG ĐẠI LÝ
-- ============================================================
CREATE TABLE dai_ly (
    id INT AUTO_INCREMENT PRIMARY KEY,
    ten_dai_ly VARCHAR(100) NOT NULL,
    dia_chi TEXT,
    so_dien_thoai VARCHAR(20),
    email VARCHAR(100),
    trang_thai TINYINT DEFAULT 1 COMMENT '1=hoạt động, 0=không hoạt động',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- ============================================================
-- BẢNG TAY EM (NHÂN VIÊN BÁN VÉ)
-- ============================================================
CREATE TABLE tay_em (
    id INT AUTO_INCREMENT PRIMARY KEY,
    ho_ten VARCHAR(100) NOT NULL,
    so_dien_thoai VARCHAR(20),
    dia_chi TEXT,
    trang_thai ENUM('hoat_dong','nghi_1_ngay','nghi_nhieu_ngay','ngung_hoat_dong') DEFAULT 'hoat_dong',
    dai_ly_id INT,
    ngay_bat_dau_lam DATE,
    ghi_chu TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (dai_ly_id) REFERENCES dai_ly(id) ON DELETE SET NULL
);

-- ============================================================
-- BẢNG NGHỈ PHÉP TAY EM
-- ============================================================
CREATE TABLE nghi_phep (
    id INT AUTO_INCREMENT PRIMARY KEY,
    tay_em_id INT NOT NULL,
    ngay_bat_dau_nghi DATE NOT NULL,
    ngay_ket_thuc_nghi DATE,
    loai_nghi ENUM('1_ngay','nhieu_ngay') DEFAULT '1_ngay',
    ly_do TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (tay_em_id) REFERENCES tay_em(id) ON DELETE CASCADE
);

-- ============================================================
-- BẢNG CẤU HÌNH GIÁ VÉ THEO TUYẾN ĐI
-- ============================================================
CREATE TABLE gia_ve (
    id INT AUTO_INCREMENT PRIMARY KEY,
    ten_tuyen VARCHAR(100) NOT NULL COMMENT 'VD: Thứ 2 - Cà Mau, Thứ 3 - Bạc Liêu...',
    ngay_trong_tuan TINYINT COMMENT '2=Thứ2, 3=Thứ3, ..., 8=Chủ Nhật',
    tinh_thanh VARCHAR(100),
    gia_ve DECIMAL(10,0) NOT NULL DEFAULT 0,
    ghi_chu TEXT,
    trang_thai TINYINT DEFAULT 1,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- ============================================================
-- BẢNG BÁN VÉ HÀNG NGÀY
-- ============================================================
CREATE TABLE ban_ve (
    id INT AUTO_INCREMENT PRIMARY KEY,
    tay_em_id INT NOT NULL,
    gia_ve_id INT NOT NULL,
    ngay_ban DATE NOT NULL,
    so_ve_ban INT DEFAULT 0,
    so_ve_e INT DEFAULT 0 COMMENT 'Vé ế (không bán được)',
    tien_dang DECIMAL(15,0) DEFAULT 0 COMMENT 'Tiền đặng = vé bán x giá vé',
    da_dang TINYINT DEFAULT 0 COMMENT '1=đã đăng, 0=chưa đăng',
    ghi_chu TEXT,
    nguoi_nhap INT COMMENT 'user id người nhập',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (tay_em_id) REFERENCES tay_em(id) ON DELETE CASCADE,
    FOREIGN KEY (gia_ve_id) REFERENCES gia_ve(id) ON DELETE CASCADE
);

-- ============================================================
-- BẢNG NGƯỜI DÙNG HỆ THỐNG
-- ============================================================
CREATE TABLE users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    ho_ten VARCHAR(100),
    email VARCHAR(100),
    role ENUM('admin','nhan_vien') DEFAULT 'nhan_vien',
    trang_thai TINYINT DEFAULT 1,
    last_login TIMESTAMP NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- ============================================================
-- BẢNG CẤU HÌNH IN ẤN
-- ============================================================
CREATE TABLE cau_hinh_in (
    id INT AUTO_INCREMENT PRIMARY KEY,
    ten_cau_hinh VARCHAR(100),
    noi_dung TEXT COMMENT 'JSON config',
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- ============================================================
-- DỮ LIỆU MẪU
-- ============================================================

-- Tài khoản admin mặc định (password: Admin@123)
INSERT INTO users (username, password, ho_ten, email, role) VALUES
('admin', '$2b$10$rQZ8kHwwCX1SqPZgEJzVL.Y9JQp3KzGZoMl1qVXx5JgUXKjY3Ei0m', 'Quản Trị Viên', 'admin@veso.com', 'admin');

-- Dữ liệu tuyến đường mẫu
INSERT INTO gia_ve (ten_tuyen, ngay_trong_tuan, tinh_thanh, gia_ve) VALUES
('Thứ 2 - Cà Mau',     2, 'Cà Mau',     10000),
('Thứ 3 - Bạc Liêu',   3, 'Bạc Liêu',   10000),
('Thứ 4 - Sóc Trăng',  4, 'Sóc Trăng',  10000),
('Thứ 5 - An Giang',   5, 'An Giang',    10000),
('Thứ 5 - Bình Thuận', 5, 'Bình Thuận',  10000),
('Thứ 6 - Trà Vinh',   6, 'Trà Vinh',    10000),
('Thứ 7 - Bình Phước', 7, 'Bình Phước',  10000),
('Thứ 7 - Hậu Giang',  7, 'Hậu Giang',  10000),
('Chủ Nhật - Kiên Giang', 8, 'Kiên Giang', 10000),
('Chủ Nhật - Đà Lạt',  8, 'Đà Lạt',     10000);

-- Đại lý mẫu
INSERT INTO dai_ly (ten_dai_ly, dia_chi, so_dien_thoai) VALUES
('Đại Lý Trung Tâm', 'TP. Cà Mau', '0901234567'),
('Đại Lý Số 2', 'Huyện Cái Nước, Cà Mau', '0912345678');
