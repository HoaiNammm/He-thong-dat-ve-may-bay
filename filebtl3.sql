CREATE DATABASE QLHTMB
ON (
    NAME = QLHTMB_data,
    FILENAME = 'C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\DATA\QLHTMB_new.mdf'
)
LOG ON (
    NAME = QLHTMB_log,
    FILENAME = 'C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\DATA\QLHTMB_new_log.ldf'
);
USE QLHTMB;

-- 1. Bảng MAYBAY
CREATE TABLE MAYBAY (
    MaMB VARCHAR(10) PRIMARY KEY,
    TenMB VARCHAR(100),
    Tongsoghe INT CHECK (Tongsoghe > 0) -- Đảm bảo tổng số ghế phải lớn hơn 0
);

-- 2. Bảng SANBAY
CREATE TABLE SANBAY (
    MaSB VARCHAR(10) PRIMARY KEY,
    TenSB VARCHAR(100),
    Tinh VARCHAR(100)			-- Tỉnh thành nơi sân bay tọa lạc
);
DROP TABLE MAYBAY
-- 3. Bảng TUYENBAY
CREATE TABLE TUYENBAY (
    Matuyen VARCHAR(10) PRIMARY KEY,
    MaSB VARCHAR(10),												-- Mã sân bay, liên kết với bảng SANBAY
    Sanbaydi VARCHAR(100),
    Sanbayden VARCHAR(100),
    FOREIGN KEY (MaSB) REFERENCES SANBAY(MaSB) ON DELETE CASCADE
);

DROP TABLE TUYENBAY
-- 4. Bảng CHUYENBAY
CREATE TABLE CHUYENBAY (
    Machuyenbay VARCHAR(10) PRIMARY KEY,
    Matuyen VARCHAR(10),
    MaMB VARCHAR(10),
    Khoihanh DATETIME,
    Thoigiandukien INT CHECK (Thoigiandukien > 0),							-- Thời gian dự kiến tính theo phút
    Soghetrong INT CHECK (Soghetrong >= 0),									-- Số ghế trống không được âm
    FOREIGN KEY (Matuyen) REFERENCES TUYENBAY(Matuyen) ON DELETE CASCADE,
    FOREIGN KEY (MaMB) REFERENCES MAYBAY(MaMB) ON DELETE CASCADE
);
DROP TABLE CHUYENBAY
-- 5. Bảng KHACHHANG
CREATE TABLE KHACHHANG (
    MaKH VARCHAR(10) PRIMARY KEY,
    TenKH VARCHAR(100),
    Diachi VARCHAR(100),
    CCCD VARCHAR(12) UNIQUE,				-- Đảm bảo CCCD không bị trùng
    Sove INT DEFAULT 0 CHECK (Sove >= 0)	-- Số vé đã mua, không âm
);
DROP table KHACHHANG
-- 6. Bảng NHANVIEN
CREATE TABLE NHANVIEN (
    MaNV VARCHAR(10) PRIMARY KEY,
    TenNV VARCHAR(100),
    Diachi VARCHAR(100),
    SDT VARCHAR(15),												-- Kiểm tra số trong ứng dụng hoặc dùng TRIGGER
    Ngaysinh DATE,
    Gioitinh VARCHAR(5) CHECK (Gioitinh IN ('Nam', 'Nữ', 'Khác')), -- Chỉ chấp nhận 3 giá trị này
    Luong DECIMAL(15,2) CHECK (Luong >= 0)
);

-- 7. Bảng VE
CREATE TABLE VE (
    Mave VARCHAR(10) PRIMARY KEY,
    Machuyenbay VARCHAR(10) NOT NULL,
    MaKH VARCHAR(10) NOT NULL,
    MaHD VARCHAR(10) NULL,					
    Hangve VARCHAR(50) NOT NULL, 
    Loaive VARCHAR(50) NOT NULL,
    Soghe INT CHECK (Soghe > 0) NOT NULL,	
    Tinhtrang VARCHAR(100) DEFAULT 'Chua Thanh Toan' CHECK (Tinhtrang IN ('Da Dat', 'Huy', 'Chua Thanh Toan')),
    FOREIGN KEY (Machuyenbay) REFERENCES CHUYENBAY(Machuyenbay) ON DELETE NO ACTION, 
    FOREIGN KEY (MaKH) REFERENCES KHACHHANG(MaKH) ON DELETE NO ACTION,
    FOREIGN KEY (MaHD) REFERENCES HOADON(MaHD) ON DELETE SET NULL
);



--8. Bảng hóa đơn
CREATE TABLE HOADON (
    MaHD VARCHAR(10) PRIMARY KEY,
    MaKH VARCHAR(10),
    MaNV VARCHAR(10) DEFAULT NULL,					-- Nếu khách hàng tự đặt vé online thì NULL
    Ngaylap DATETIME DEFAULT CURRENT_TIMESTAMP,		-- Lưu cả ngày và giờ
    Thanhtien DECIMAL(15,2) CHECK (Thanhtien >= 0),		-- Thành tiền không được âm
    FOREIGN KEY (MaKH) REFERENCES KHACHHANG(MaKH) 
        ON DELETE CASCADE 
        ON UPDATE CASCADE,								-- Cập nhật khi MaKH thay đổi
    FOREIGN KEY (MaNV) REFERENCES NHANVIEN(MaNV) 
        ON DELETE SET NULL 
        ON UPDATE CASCADE								-- Cập nhật khi MaNV thay đổi
);



