 DATABASE QLHTMB

-- 1. Dữ liệu bảng MAYBAY
INSERT INTO MAYBAY (MaMB, TenMB, Tongsoghe) VALUES
('MB001', 'Boeing 737', 180),
('MB002', 'Airbus A320', 150),
('MB003', 'Boeing 777', 396),
('MB004', 'Airbus A380', 555),
('MB005', 'Embraer E190', 100),
('MB006', 'Boeing 787', 296),
('MB007', 'Airbus A321', 220),
('MB008', 'Bombardier CRJ900', 90),
('MB009', 'Boeing 747', 416),
('MB010', 'Airbus A319', 140),
('MB011', 'Boeing 767', 375),
('MB012', 'ATR 72', 78),
('MB013', 'Boeing 757', 239),
('MB014', 'Airbus A350', 350),
('MB015', 'McDonnell Douglas MD-80', 155);

SELECT*FROM MAYBAY
-- 2. Dữ liệu bảng SANBAY


INSERT INTO SANBAY (MaSB, TenSB, Tinh) VALUES
('SB001', 'Nội Bài', 'Hà Nội'),
('SB002', 'Tân Sơn Nhất', 'TP.HCM'),
('SB003', 'Đà Nẵng', 'Đà Nẵng'),
('SB004', 'Cam Ranh', 'Khánh Hòa'),
('SB005', 'Phú Quốc', 'Kiên Giang'),
('SB006', 'Cát Bi', 'Hải Phòng'),
('SB007', 'Vinh', 'Nghệ An'),
('SB008', 'Liên Khương', 'Lâm Đồng'),
('SB009', 'Chu Lai', 'Quảng Nam'),
('SB010', 'Cần Thơ', 'Cần Thơ'),
('SB011', 'Thọ Xuân', 'Thanh Hóa'),
('SB012', 'Buôn Ma Thuột', 'Đắk Lắk'),
('SB013', 'Pleiku', 'Gia Lai'),
('SB014', 'Rạch Giá', 'Kiên Giang'),
('SB015', 'Điện Biên Phủ', 'Điện Biên');
SELECT*FROM SANBAY
-- 3. Dữ liệu bảng TUYENBAY
DELETE FROM SANBAY;

INSERT INTO TUYENBAY (Matuyen, MaSB, Sanbaydi, Sanbayden) VALUES
('TB001', 'SB001', 'NoiBai', 'TanSonNhat'),
('TB002', 'SB002', 'TanSonNhat', 'DaNang'),
('TB003', 'SB003', 'DaNang', 'CamRanh'),
('TB004', 'SB004', 'CamRanh', 'PhuQuoc'),
('TB005', 'SB005', 'PhuQuoc', 'NoiBai'),
('TB006', 'SB006', 'CatBi', 'Vinh'),
('TB007', 'SB007', 'Vinh', 'TanSonNhat'),
('TB008', 'SB008', 'LienKhuong', 'DaNang'),
('TB009', 'SB009', 'ChuLai', 'CanTho'),
('TB010', 'SB010', 'CanTho', 'TanSonNhat'),
('TB011', 'SB011', 'ThoXuan', 'NoiBai'),
('TB012', 'SB012', 'BuonMaThuot', 'DaNang'),
('TB013', 'SB013', 'Pleiku', 'CamRanh'),
('TB014', 'SB014', 'RachGia', 'TanSonNhat'),
('TB015', 'SB015', 'DienBien', 'NoiBai');

SELECT*FROM TUYENBAY
-- 4. Dữ liệu bảng CHUYENBAY
INSERT INTO CHUYENBAY (Machuyenbay, Matuyen, MaMB, Khoihanh, Thoigiandukien, Soghetrong) VALUES
('CB001', 'TB001', 'MB001', '2025-05-10 08:00:00', 120, 50),
('CB002', 'TB002', 'MB002', '2025-05-10 09:00:00', 90, 30),
('CB003', 'TB003', 'MB003', '2025-06-10 10:00:00', 135, 100),
('CB004', 'TB004', 'MB004', '2025-05-10 11:00:00', 105, 75),
('CB005', 'TB005', 'MB005', '2025-06-10 12:00:00', 150, 60),
('CB006', 'TB006', 'MB006', '2025-07-10 13:00:00', 80, 90),
('CB007', 'TB007', 'MB007', '2025-08-10 14:00:00', 130, 55),
('CB008', 'TB008', 'MB008', '2025-09-10 15:00:00', 110, 40),
('CB009', 'TB009', 'MB009', '2025-09-10 16:00:00', 160, 20),
('CB010', 'TB010', 'MB010', '2025-05-10 17:00:00', 120, 45),
('CB011', 'TB011', 'MB011', '2025-05-10 18:00:00', 90, 70),
('CB012', 'TB012', 'MB012', '2025-06-10 19:00:00', 70, 80),
('CB013', 'TB013', 'MB013', '2025-07-10 20:00:00', 125, 95),
('CB014', 'TB014', 'MB014', '2025-08-10 21:00:00', 140, 110),
('CB015', 'TB015', 'MB015', '2025-05-10 22:00:00', 100, 85);
SELECT*FROM CHUYENBAY
TRUNCATE TABLE CHUYENBAY;

-- 5. Dữ liệu bảng KHACHHANG
INSERT INTO KHACHHANG (MaKH, TenKH, Diachi, CCCD, Sove) VALUES
('KH001', 'Nguyễn Văn Vinh', 'Hà Nội', '123456789012', 0),
('KH002', 'TTrần Mạnh Tiến', 'TP.HCM', '234567890123', 1),
('KH003', 'Lê Văn Cao', 'Đà Nẵng', '345678901234', 3),
('KH004', 'Phạm Văn Huy', 'Khánh Hòa', '456789012345', 1),
('KH005', 'Nguyễn Hoàng Anh', 'Kiên Giang', '567890123456', 0),
('KH006', 'Đỗ Văn Vinh', 'Hải Phòng', '678901234567', 2),
('KH007', 'Bùi Thế Hoàng', 'Nghệ An', '789012345678', 1),
('KH008', 'Nguyễn Phương Nam', 'Lâm Đồng', '890123456789', 1),
('KH009', 'Lã Tiến Đạt', 'Quảng Nam', '901234567890', 3),
('KH010', 'Dương Thị Hoài', 'Cần Thơ', '012345678901', 4),
('KH011', 'Lại Thành Đoàn', 'Thanh Hóa', '123456789023', 1),
('KH012', 'Nguyễn Minh Thức', 'Đắk Lắk', '234567890145', 0),
('KH013', 'Trần Quốc Hùng', 'Gia Lai', '345678901267', 0),
('KH014', 'Bạch Ngọc Lương', 'Kiên Giang', '456789012389', 2),
('KH015', 'Đinh Trường Phong', 'Điện Biên', '567890123401', 1);
SELECT*FROM KHACHHANG

-- 6. Dữ liệu bảng NHANVIEN
INSERT INTO NHANVIEN (MaNV, TenNV, Diachi, SDT, Ngaysinh, Gioitinh, Luong) VALUES
('NV001', 'Nguyễn Hữu An', 'Hà Nội', '0986543210', '1990-05-15', 'Nam', 15000000),
('NV002', 'Trần Thanh Bình', 'TP.HCM', '0975432109', '1988-07-20', 'Nam', 13000000),
('NV003', 'Lê Thị Cẩm', 'Đà Nẵng', '0964321098', '1992-03-10', 'Nữ', 12000000),
('NV004', 'Phạm Hùng Dũng', 'Khánh Hòa', '0953210987', '1985-11-25', 'Nam', 20000000),
('NV005', 'Hoàng Thị Em', 'Kiên Giang', '0942109876', '1993-09-12', 'Nữ', 11000000),
('NV006', 'Đỗ Hồng Phúc', 'Hải Phòng', '0931098765', '1987-06-18', 'Nam', 14000000),
('NV007', 'Bùi Thanh Sơn', 'Nghệ An', '0920987654', '1991-04-30', 'Nam', 13000000),
('NV008', 'Ngô Đức Hòa', 'Lâm Đồng', '0919876543', '1989-08-05', 'Nam', 15000000),
('NV009', 'Vũ Trường Giang', 'Quảng Nam', '0908765432', '1994-02-22', 'Nam', 12000000),
('NV010', 'Dương Minh Khang', 'Cần Thơ', '0897654321', '1986-12-15', 'Nam', 13000000),
('NV011', 'Trịnh Thị Lam', 'Thanh Hóa', '0886543210', '1995-01-10', 'Nữ', 11000000),
('NV012', 'Lương Hoàng Nam', 'Đắk Lắk', '0875432109', '1984-10-20', 'Nam', 14000000),
('NV013', 'Tô Văn Quân', 'Gia Lai', '0864321098', '1990-07-08', 'Nam', 15000000),
('NV014', 'Phùng Ngọc Sơn', 'Kiên Giang', '0853210987', '1988-09-14', 'Nam', 13000000),
('NV015', 'Hà Thị Uyên', 'Điện Biên', '0842109876', '1993-11-03', 'Nữ', 12000000);
SELECT*FROM NHANVIEN
-- 7. Dữ liệu bảng HOADON
INSERT INTO HOADON (MaHD, MaKH, MaNV, Thanhtien) VALUES
('HD001', 'KH001', 'NV001', 1500000),
('HD002', 'KH002', 'NV002', 2200000),
('HD003', 'KH003', 'NV003', 1800000),
('HD004', 'KH004', 'NV004', 2600000),
('HD005', 'KH005', NULL, 1400000),
('HD006', 'KH006', 'NV006', 2000000);
SELECT*FROM HOADON


INSERT INTO VE (Mave, Machuyenbay, MaKH, MaHD, Hangve, Loaive, Soghe, Tinhtrang) VALUES
('VE001', 'CB001', 'KH001', 'HD001', 'Hạng Phổ Thông', 'Vé Một Chiều', 1, 'Da Dat'),
('VE002', 'CB002', 'KH002', 'HD002', 'Hạng Thương Gia', 'Vé Khứ Hồi', 2, 'Da Dat'),
('VE003', 'CB003', 'KH003', 'HD003', 'Hạng Phổ Thông', 'Vé Một Chiều', 3, 'Chua Thanh Toan'),
('VE004', 'CB004', 'KH004', 'HD004', 'Hạng Thương Gia', 'Vé Khứ Hồi', 4, 'Da Dat'),
('VE005', 'CB005', 'KH005', 'HD005', 'Hạng Phổ Thông', 'Vé Một Chiều', 5, 'Chua Thanh Toan'),
('VE006', 'CB006', 'KH006', 'HD006', 'Hạng Phổ Thông', 'Vé Một Chiều', 6, 'Da Dat');
SELECT*FROM VE