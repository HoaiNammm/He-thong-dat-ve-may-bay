--1. Thêm máy bay phải 50 ghế
CREATE TRIGGER trg_SimpleCheckGheMayBay
ON MAYBAY
INSTEAD OF INSERT
AS
BEGIN
    IF EXISTS (SELECT 1 FROM inserted WHERE Tongsoghe < 50)
    BEGIN
        PRINT 'Số ghế phải từ 50 trở lên!';
        RETURN;
    END
    INSERT INTO MAYBAY SELECT * FROM inserted;
END;

-- Thử thêm máy bay với số ghế < 50 (sẽ báo lỗi)
INSERT INTO MAYBAY (MaMB, TenMB, Tongsoghe) 
VALUES ('MB016', 'Test Plane', 40); -- Kết quả: In "Số ghế phải từ 50 trở lên!"

-- Thử thêm máy bay với số ghế >= 50 (thành công)
INSERT INTO MAYBAY (MaMB, TenMB, Tongsoghe) 
VALUES ('MB016', 'Test Plane', 60); 
SELECT * FROM MAYBAY WHERE MaMB = 'MB016'; -- Kết quả: Thấy MB016

--2. Trigger tăng số vé khách hàng khi thêm vé
CREATE TRIGGER trg_SimpleTangSoVe
ON VE
AFTER INSERT
AS
BEGIN
    UPDATE KHACHHANG
    SET Sove = Sove + 1
    FROM KHACHHANG k
    JOIN inserted i ON k.MaKH = i.MaKH;
END;

-- Kiểm tra Sove ban đầu của KH001
SELECT MaKH, Sove FROM KHACHHANG WHERE MaKH = 'KH001'; -- Kết quả: Sove = 0

-- Thêm vé mới
INSERT INTO VE (Mave, Machuyenbay, MaKH, MaHD, Hangve, Loaive, Soghe, Tinhtrang)
VALUES ('VE007', 'CB001', 'KH001', 'HD001', 'Hạng Phổ Thông', 'Vé Một Chiều', 1, 'Da Dat');

-- Kiểm tra lại Sove
SELECT MaKH, Sove FROM KHACHHANG WHERE MaKH = 'KH001'; -- Kết quả: Sove = 1

--3. Trigger không cho sửa thời gian khởi hành về quá khứ

CREATE TRIGGER trg_SimpleCheckKhoiHanh
ON CHUYENBAY
INSTEAD OF UPDATE
AS
BEGIN
    IF EXISTS (SELECT 1 FROM inserted WHERE Khoihanh < GETDATE())
    BEGIN
        PRINT 'Không được sửa thời gian khởi hành về quá khứ!';
        RETURN;
    END
    UPDATE CHUYENBAY
    SET Khoihanh = i.Khoihanh
    FROM inserted i
    WHERE CHUYENBAY.Machuyenbay = i.Machuyenbay;
END;

-- Thử sửa về quá khứ (sẽ báo lỗi)
UPDATE CHUYENBAY 
SET Khoihanh = '2025-03-01 08:00:00' 
WHERE Machuyenbay = 'CB001'; -- Kết quả: In "Không được sửa về quá khứ!"

-- Thử sửa về tương lai (thành công)
UPDATE CHUYENBAY 
SET Khoihanh = '2025-06-01 08:00:00' 
WHERE Machuyenbay = 'CB001'; 
SELECT Khoihanh FROM CHUYENBAY WHERE Machuyenbay = 'CB001'; -- Kết quả: 2025-06-01

--4. Trigger giảm số ghế trống khi thêm vé
CREATE TRIGGER trg_SimpleGiamGheTrong
ON VE
AFTER INSERT
AS
BEGIN
    UPDATE CHUYENBAY
    SET Soghetrong = Soghetrong - 1
    FROM CHUYENBAY c
    JOIN inserted i ON c.Machuyenbay = i.Machuyenbay;
END;

-- Kiểm tra số ghế trống ban đầu
SELECT Soghetrong FROM CHUYENBAY WHERE Machuyenbay = 'CB001'; -- Kết quả: 50

-- Thêm vé mới
INSERT INTO VE (Mave, Machuyenbay, MaKH, MaHD, Hangve, Loaive, Soghe, Tinhtrang)
VALUES ('VE008', 'CB001', 'KH001', 'HD001', 'Hạng Phổ Thông', 'Vé Một Chiều', 1, 'Da Dat');

-- Kiểm tra lại
SELECT Soghetrong FROM CHUYENBAY WHERE Machuyenbay = 'CB001'; -- Kết quả: 49

--5. Trigger không cho thêm nhân viên nếu lương dưới 5 triệu

CREATE TRIGGER trg_SimpleCheckLuong
ON NHANVIEN
INSTEAD OF INSERT
AS
BEGIN
    IF EXISTS (SELECT 1 FROM inserted WHERE Luong < 5000000)
    BEGIN
        PRINT 'Lương phải từ 5 triệu trở lên!';
        RETURN;
    END
    INSERT INTO NHANVIEN SELECT * FROM inserted;
END;

-- Thử thêm nhân viên với lương < 5 triệu (sẽ báo lỗi)
INSERT INTO NHANVIEN (MaNV, TenNV, Diachi, SDT, Ngaysinh, Gioitinh, Luong)
VALUES ('NV016', 'Nguyen Van A', 'Hà Nội', '0901234567', '1990-01-01', 'Nam', 4000000); 
-- Kết quả: In "Lương phải từ 5 triệu trở lên!"

-- Thử thêm với lương >= 5 triệu (thành công)
INSERT INTO NHANVIEN (MaNV, TenNV, Diachi, SDT, Ngaysinh, Gioitinh, Luong)
VALUES ('NV016', 'Nguyen Van A', 'Hà Nội', '0901234567', '1990-01-01', 'Nam', 6000000);
SELECT * FROM NHANVIEN WHERE MaNV = 'NV016'; -- Thấy NV016

--6. Trigger tự động đặt trạng thái vé thành 'Huy' khi xóa chuyến bay

CREATE TRIGGER trg_SimpleHuyVe
ON CHUYENBAY
AFTER DELETE
AS
BEGIN
    UPDATE VE
    SET Tinhtrang = 'Huy'
    FROM VE v
    JOIN deleted d ON v.Machuyenbay = d.Machuyenbay;
END;

-- Kiểm tra trạng thái vé ban đầu
SELECT Tinhtrang FROM VE WHERE Mave = 'VE001'; -- Kết quả: 'Da Dat'

-- Xóa chuyến bay
DELETE FROM CHUYENBAY WHERE Machuyenbay = 'CB001';

-- Kiểm tra lại trạng thái vé
SELECT Tinhtrang FROM VE WHERE Mave = 'VE001'; -- Kết quả: 'Huy'

--7. Trigger không cho thêm vé nếu số ghế âm
CREATE TRIGGER trg_SimpleCheckSoGheVe
ON VE
INSTEAD OF INSERT
AS
BEGIN
    IF EXISTS (SELECT 1 FROM inserted WHERE Soghe < 0)
    BEGIN
        PRINT 'Số ghế không được âm!';
        RETURN;
    END
    INSERT INTO VE SELECT * FROM inserted;
END;

-- Thử thêm vé với số ghế âm (sẽ báo lỗi)
INSERT INTO VE (Mave, Machuyenbay, MaKH, MaHD, Hangve, Loaive, Soghe, Tinhtrang)
VALUES ('VE009', 'CB002', 'KH002', 'HD002', 'Hạng Thương Gia', 'Vé Khứ Hồi', -1, 'Da Dat');
-- Kết quả: In "Số ghế không được âm!"

-- Thử thêm với số ghế hợp lệ (thành công)
INSERT INTO VE (Mave, Machuyenbay, MaKH, MaHD, Hangve, Loaive, Soghe, Tinhtrang)
VALUES ('VE009', 'CB002', 'KH002', 'HD002', 'Hạng Thương Gia', 'Vé Khứ Hồi', 1, 'Da Dat');
SELECT * FROM VE WHERE Mave = 'VE009'; -- Thấy VE009

--8. Trigger tăng thành tiền hóa đơn khi thêm vé
CREATE TRIGGER trg_SimpleTangThanhTien
ON VE
AFTER INSERT
AS
BEGIN
    UPDATE HOADON
    SET Thanhtien = Thanhtien + 1000000
    FROM HOADON h
    JOIN inserted i ON h.MaHD = i.MaHD;
END;

-- Kiểm tra thành tiền ban đầu
SELECT Thanhtien FROM HOADON WHERE MaHD = 'HD001'; -- Kết quả: 1500000

-- Thêm vé mới
INSERT INTO VE (Mave, Machuyenbay, MaKH, MaHD, Hangve, Loaive, Soghe, Tinhtrang)
VALUES ('VE010', 'CB001', 'KH001', 'HD001', 'Hạng Phổ Thông', 'Vé Một Chiều', 1, 'Da Dat');

-- Kiểm tra lại
SELECT Thanhtien FROM HOADON WHERE MaHD = 'HD001'; -- Kết quả: 2500000

--9. Trigger không cho sửa sân bay nếu tên trống

CREATE TRIGGER trg_SimpleCheckTenSanBay
ON SANBAY
INSTEAD OF UPDATE
AS
BEGIN
    IF EXISTS (SELECT 1 FROM inserted WHERE TenSB = '')
    BEGIN
        PRINT 'Tên sân bay không được để trống!';
        RETURN;
    END
    UPDATE SANBAY
    SET TenSB = i.TenSB, Tinh = i.Tinh
    FROM inserted i
    WHERE SANBAY.MaSB = i.MaSB;
END;

-- Thử sửa tên sân bay thành trống (sẽ báo lỗi)
UPDATE SANBAY 
SET TenSB = '' 
WHERE MaSB = 'SB001'; -- Kết quả: In "Tên sân bay không được để trống!"

-- Thử sửa tên hợp lệ (thành công)
UPDATE SANBAY 
SET TenSB = 'Nội Bài Mới' 
WHERE MaSB = 'SB001'; 
SELECT TenSB FROM SANBAY WHERE MaSB = 'SB001'; -- Kết quả: 'Nội Bài Mới'

--10. Trigger tăng số ghế trống khi xóa vé

CREATE TRIGGER trg_SimpleTangGheTrong
ON VE
AFTER DELETE
AS
BEGIN
    UPDATE CHUYENBAY
    SET Soghetrong = Soghetrong + 1
    FROM CHUYENBAY c
    JOIN deleted d ON c.Machuyenbay = d.Machuyenbay;
END;

-- Kiểm tra số ghế trống ban đầu
SELECT Soghetrong FROM CHUYENBAY WHERE Machuyenbay = 'CB001'; -- Kết quả: 50

-- Xóa vé
DELETE FROM VE WHERE Mave = 'VE001';

-- Kiểm tra lại
SELECT Soghetrong FROM CHUYENBAY WHERE Machuyenbay = 'CB001'; -- Kết quả: 51


--CHƯƠNG 7. PHÂN QUYỀN VÀ BẢO VỆ CƠ SỞ DỮ LIỆU

USE master;

-- tạo tài khoản
-- Tạo login cho Quản lý
CREATE LOGIN QuanLy WITH PASSWORD = 'QuanLy123';

-- Tạo login cho Nhân viên
CREATE LOGIN NhanVien WITH PASSWORD = 'NhanVien123';

-- Tạo login cho Khách hàng
CREATE LOGIN KhachHang WITH PASSWORD = 'KhachHang123';

-- tạo người dùng 

USE QLHTMB;

-- Tạo user cho Quản lý
CREATE USER QuanLy FOR LOGIN QuanLy;

-- Tạo user cho Nhân viên
CREATE USER NhanVien FOR LOGIN NhanVien;

-- Tạo user cho Khách hàng
CREATE USER KhachHang FOR LOGIN KhachHang;

-- TẠO VAI TRÒ

-- Vai trò cho Quản lý (toàn quyền)
CREATE ROLE QuanLyRole;

-- Vai trò cho Nhân viên (quyền giới hạn)
CREATE ROLE NhanVienRole;

-- Vai trò cho Khách hàng (chỉ xem và thêm giới hạn)
CREATE ROLE KhachHangRole;

-- Gán user vào role
ALTER ROLE QuanLyRole ADD MEMBER QuanLy;
ALTER ROLE NhanVienRole ADD MEMBER NhanVien;
ALTER ROLE KhachHangRole ADD MEMBER KhachHang;

-- PHÂN QUYỀN CHO TỪNG VAI TRÒ
--QUYỀN QL
-- Cấp toàn quyền trên tất cả bảng
GRANT SELECT, INSERT, UPDATE, DELETE ON MAYBAY TO QuanLyRole;
GRANT SELECT, INSERT, UPDATE, DELETE ON SANBAY TO QuanLyRole;
GRANT SELECT, INSERT, UPDATE, DELETE ON TUYENBAY TO QuanLyRole;
GRANT SELECT, INSERT, UPDATE, DELETE ON CHUYENBAY TO QuanLyRole;
GRANT SELECT, INSERT, UPDATE, DELETE ON KHACHHANG TO QuanLyRole;
GRANT SELECT, INSERT, UPDATE, DELETE ON NHANVIEN TO QuanLyRole;
GRANT SELECT, INSERT, UPDATE, DELETE ON VE TO QuanLyRole;
GRANT SELECT, INSERT, UPDATE, DELETE ON HOADON TO QuanLyRole;

-- Quyền quản trị (tạo bảng, trigger, v.v.)
GRANT ALTER, CONTROL ON DATABASE::QLHTMB TO QuanLyRole;

-- QUYỀN NV
-- Quyền xem trên tất cả bảng
GRANT SELECT ON MAYBAY TO NhanVienRole;
GRANT SELECT ON SANBAY TO NhanVienRole;
GRANT SELECT ON TUYENBAY TO NhanVienRole;
GRANT SELECT ON CHUYENBAY TO NhanVienRole;
GRANT SELECT ON KHACHHANG TO NhanVienRole;
GRANT SELECT ON NHANVIEN TO NhanVienRole;
GRANT SELECT ON VE TO NhanVienRole;
GRANT SELECT ON HOADON TO NhanVienRole;

-- Quyền thêm/sửa trên bảng liên quan đến công việc
GRANT INSERT, UPDATE ON CHUYENBAY TO NhanVienRole; -- Quản lý chuyến bay
GRANT INSERT, UPDATE ON VE TO NhanVienRole; -- Đặt vé
GRANT INSERT, UPDATE ON HOADON TO NhanVienRole; -- Tạo hóa đơn

-- Không cấp quyền DELETE để tránh xóa dữ liệu

--quyền KH
-- Quyền xem thông tin công khai
GRANT SELECT ON CHUYENBAY TO KhachHangRole; -- Xem chuyến bay
GRANT SELECT ON SANBAY TO KhachHangRole; -- Xem sân bay
GRANT SELECT ON TUYENBAY TO KhachHangRole; -- Xem tuyến bay

-- Quyền thêm dữ liệu cá nhân
GRANT INSERT ON VE TO KhachHangRole; -- Đặt vé
GRANT INSERT ON HOADON TO KhachHangRole; -- Tạo hóa đơn
GRANT SELECT, UPDATE ON KHACHHANG TO KhachHangRole; -- Xem và sửa thông tin cá nhân

--TEST

-- Đăng nhập bằng QuanLy (QuanLy/QuanLy123) trong SSMS
USE QLHTMB;
-- Thử thêm dữ liệu
INSERT INTO MAYBAY (MaMB, TenMB, Tongsoghe) VALUES ('MB017', 'Test Plane', 110);

SELECT MaMB FROM MAYBAY WHERE MaMB = 'MB017'; -- Kết quả: 
-- Thử xóa
DELETE FROM MAYBAY WHERE MaMB = 'MB017';
-- Kết quả: Thành công (toàn quyền)
--NV


-- Đăng nhập bằng NhanVien (NhanVien/NhanVien123)
USE QLHTMB;
-- Thử xem
SELECT * FROM CHUYENBAY; -- Thành công
-- Thử thêm
INSERT INTO VE (Mave, Machuyenbay, MaKH, MaHD, Hangve, Loaive, Soghe, Tinhtrang)
VALUES ('VE007', 'CB001', 'KH001', 'HD001', 'Hạng Phổ Thông', 'Vé Một Chiều', 1, 'Da Dat'); -- Thành công
-- Thử xóa
DELETE FROM VE WHERE Mave = 'VE007'; -- Thất bại (không có quyền DELETE)

--  KH
-- Đăng nhập bằng KhachHang (KhachHang/KhachHang123)
USE QLHTMB;
-- Thử xem
SELECT * FROM CHUYENBAY; -- Thành công
-- Thử thêm vé
INSERT INTO VE (Mave, Machuyenbay, MaKH, MaHD, Hangve, Loaive, Soghe, Tinhtrang)
VALUES ('VE008', 'CB001', 'KH001', 'HD001', 'Hạng Phổ Thông', 'Vé Một Chiều', 1, 'Da Dat'); -- Thành công
-- Thử sửa chuyến bay
UPDATE CHUYENBAY SET Khoihanh = '2025-06-01 08:00:00' WHERE Machuyenbay = 'CB001'; -- Thất bại (không có quyền UPDATE)


-----------------------------
-- Bật tính năng mã hóa cột (chạy một lần duy nhất)
CREATE MASTER KEY ENCRYPTION BY PASSWORD = '123@';

CREATE CERTIFICATE Cert_VE WITH SUBJECT = N'Mã hóa dữ liệu bảng vé';
CREATE SYMMETRIC KEY Key_VE WITH ALGORITHM = AES_256 ENCRYPTION BY CERTIFICATE Cert_VE;

-- Thêm cột mã hóa vào bảng VE
ALTER TABLE VE ADD MaKH_MaHoa VARBINARY(MAX), MaHD_MaHoa VARBINARY(MAX);

-- Mã hóa dữ liệu khi nhập vào
OPEN SYMMETRIC KEY Key_VE DECRYPTION BY CERTIFICATE Cert_VE;
UPDATE VE 
SET MaKH_MaHoa = EncryptByKey(Key_GUID('Key_VE'), MaKH),
    MaHD_MaHoa = EncryptByKey(Key_GUID('Key_VE'), MaHD);
CLOSE SYMMETRIC KEY Key_VE;

-- Giải mã khi cần xem dữ liệu
OPEN SYMMETRIC KEY Key_VE DECRYPTION BY CERTIFICATE Cert_VE;
SELECT Mave, 
       CONVERT(VARCHAR, DecryptByKey(MaKH_MaHoa)) AS MaKH_GiaiMa, 
       CONVERT(VARCHAR, DecryptByKey(MaHD_MaHoa)) AS MaHD_GiaiMa
FROM VE;
CLOSE SYMMETRIC KEY Key_VE;

-- Kiểm tra dữ liệu mã hóa
SELECT Mave, MaKH, MaHD, MaKH_MaHoa, MaHD_MaHoa FROM VE;


