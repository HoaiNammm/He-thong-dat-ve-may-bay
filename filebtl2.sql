-- tạo procedure 
-- thêm 1 máy bay mới
CREATE PROCEDURE sp_ThemMayBay
    @MaMB VARCHAR(10),
    @TenMB VARCHAR(100),
    @Tongsoghe INT
AS
BEGIN
    IF EXISTS (SELECT 1 FROM MAYBAY WHERE MaMB = @MaMB)
        PRINT 'Mã máy bay đã tồn tại!'
    ELSE
    BEGIN
        INSERT INTO MAYBAY (MaMB, TenMB, Tongsoghe)
        VALUES (@MaMB, @TenMB, @Tongsoghe)
        PRINT 'Thêm máy bay thành công!'
    END
END;

EXEC sp_ThemMayBay 'MB016', 'Boeing 737 MAX', 200;

--2. Thêm một khách hàng mới
CREATE PROCEDURE sp_ThemKhachHang
    @MaKH VARCHAR(10),
    @TenKH VARCHAR(100),
    @Diachi VARCHAR(100),
    @CCCD VARCHAR(12),
    @Sove INT = 0
AS
BEGIN
    IF EXISTS (SELECT 1 FROM KHACHHANG WHERE CCCD = @CCCD)
        PRINT 'CCCD đã tồn tại!'
    ELSE IF EXISTS (SELECT 1 FROM KHACHHANG WHERE MaKH = @MaKH)
        PRINT 'Mã khách hàng đã tồn tại!'
    ELSE
    BEGIN
        INSERT INTO KHACHHANG (MaKH, TenKH, Diachi, CCCD, Sove)
        VALUES (@MaKH, @TenKH, @Diachi, @CCCD, @Sove)
        PRINT 'Thêm khách hàng thành công!'
    END
END;
EXEC sp_ThemKhachHang 'KH016', 'Le Thi Hoa', 'Hanoi', '678901234512', 0;

--3. Cập nhật số ghế trống của chuyến bay
CREATE PROCEDURE sp_CapNhatSoGheTrong
    @Machuyenbay VARCHAR(10),
    @Soghetrong INT
AS
BEGIN
    IF NOT EXISTS (SELECT 1 FROM CHUYENBAY WHERE Machuyenbay = @Machuyenbay)
        PRINT 'Chuyến bay không tồn tại!'
    ELSE IF @Soghetrong < 0
        PRINT 'Số ghế trống không thể âm!'
    ELSE
    BEGIN
        UPDATE CHUYENBAY
        SET Soghetrong = @Soghetrong
        WHERE Machuyenbay = @Machuyenbay
        PRINT 'Cập nhật số ghế trống thành công!'
    END
END;
EXEC sp_CapNhatSoGheTrong 'CB001', 45;

--4. Xóa một tuyến bay
CREATE PROCEDURE sp_XoaTuyenBay
    @Matuyen VARCHAR(10)
AS
BEGIN
    IF NOT EXISTS (SELECT 1 FROM TUYENBAY WHERE Matuyen = @Matuyen)
        PRINT 'Tuyến bay không tồn tại!'
    ELSE
    BEGIN
        DELETE FROM TUYENBAY
        WHERE Matuyen = @Matuyen
        PRINT 'Xóa tuyến bay thành công!'
    END
END;
EXEC sp_XoaTuyenBay 'TB015';

--5.Thêm vé mới và cập nhật số ghế trống
CREATE PROCEDURE sp_DatVe
    @Mave VARCHAR(10),
    @Machuyenbay VARCHAR(10),
    @MaKH VARCHAR(10),
    @Hangve VARCHAR(50),
    @Loaive VARCHAR(50),
    @Soghe INT
AS
BEGIN
    DECLARE @Soghetrong INT
    SELECT @Soghetrong = Soghetrong FROM CHUYENBAY WHERE Machuyenbay = @Machuyenbay

    IF @Soghetrong IS NULL
        PRINT 'Chuyến bay không tồn tại!'
    ELSE IF @Soghetrong < @Soghe
        PRINT 'Không đủ ghế trống!'
    ELSE
    BEGIN
        INSERT INTO VE (Mave, Machuyenbay, MaKH, Hangve, Loaive, Soghe)
        VALUES (@Mave, @Machuyenbay, @MaKH, @Hangve, @Loaive, @Soghe)

        UPDATE CHUYENBAY
        SET Soghetrong = Soghetrong - @Soghe
        WHERE Machuyenbay = @Machuyenbay

        UPDATE KHACHHANG
        SET Sove = Sove + 1
        WHERE MaKH = @MaKH

        PRINT 'Đặt vé thành công!'
    END
END;
EXEC sp_DatVe 'VE007', 'CB001', 'KH001', 'Hạng Phổ Thông', 'Vé Một Chiều', 1;

--6. tìm chuyến bay theo ngày
CREATE PROCEDURE sp_TimChuyenBayTheoNgay
    @Ngay DATE
AS
BEGIN
    SELECT CB.Machuyenbay, TB.Sanbaydi, TB.Sanbayden, CB.Khoihanh, CB.Soghetrong
    FROM CHUYENBAY CB
    JOIN TUYENBAY TB ON CB.Matuyen = TB.Matuyen
    WHERE CAST(CB.Khoihanh AS DATE) = @Ngay
END;
EXEC sp_TimChuyenBayTheoNgay '2025-03-10';

-- 7. hủy vé và cập nhật lại số ghế trống
CREATE PROCEDURE sp_HuyVe
    @Mave VARCHAR(10)
AS
BEGIN
    DECLARE @Machuyenbay VARCHAR(10), @Soghe INT

    SELECT @Machuyenbay = Machuyenbay, @Soghe = Soghe
    FROM VE
    WHERE Mave = @Mave

    IF @Machuyenbay IS NULL
        PRINT 'Vé không tồn tại!'
    ELSE
    BEGIN
        UPDATE VE
        SET Tinhtrang = 'Huy'
        WHERE Mave = @Mave

        UPDATE CHUYENBAY
        SET Soghetrong = Soghetrong + @Soghe
        WHERE Machuyenbay = @Machuyenbay

        UPDATE KHACHHANG
        SET Sove = Sove - 1
        WHERE MaKH = (SELECT MaKH FROM VE WHERE Mave = @Mave)

        PRINT 'Hủy vé thành công!'
    END
END;
EXEC sp_HuyVe 'VE003';

--8. tính tổng tiền hóa đơn của khách hàng
CREATE PROCEDURE sp_TinhTongTienHoaDon
    @MaKH VARCHAR(10)
AS
BEGIN
    SELECT HD.MaHD, HD.Ngaylap, HD.Thanhtien
    FROM HOADON HD
    WHERE HD.MaKH = @MaKH

    SELECT SUM(Thanhtien) AS TongTien
    FROM HOADON
    WHERE MaKH = @MaKH
END;
EXEC sp_TinhTongTienHoaDon 'KH001';

--9. thêm nhân viên mới
CREATE PROCEDURE sp_ThemNhanVien
    @MaNV VARCHAR(10),
    @TenNV VARCHAR(100),
    @Diachi VARCHAR(100),
    @SDT VARCHAR(15),
    @Ngaysinh DATE,
    @Gioitinh VARCHAR(5),
    @Luong DECIMAL(15,2)
AS
BEGIN
    IF EXISTS (SELECT 1 FROM NHANVIEN WHERE MaNV = @MaNV)
        PRINT 'Mã nhân viên đã tồn tại!'
    ELSE
    BEGIN
        INSERT INTO NHANVIEN (MaNV, TenNV, Diachi, SDT, Ngaysinh, Gioitinh, Luong)
        VALUES (@MaNV, @TenNV, @Diachi, @SDT, @Ngaysinh, @Gioitinh, @Luong)
        PRINT 'Thêm nhân viên thành công!'
    END
END;
EXEC sp_ThemNhanVien 'NV016', 'Nguyen Van X', 'Hanoi', '0987654321', '1990-01-01', 'Nam', 12000000;

-- 10. thống kê số vé theo chuyến bay
CREATE PROCEDURE sp_ThongKeVeTheoChuyenBay
    @Machuyenbay VARCHAR(10)
AS
BEGIN
    SELECT V.Machuyenbay, COUNT(V.Mave) AS TongSoVe, 
           SUM(CASE WHEN V.Tinhtrang = 'Da Dat' THEN 1 ELSE 0 END) AS VeDaDat,
           SUM(CASE WHEN V.Tinhtrang = 'Huy' THEN 1 ELSE 0 END) AS VeDaHuy
    FROM VE V
    WHERE V.Machuyenbay = @Machuyenbay
    GROUP BY V.Machuyenbay
END;
EXEC sp_ThongKeVeTheoChuyenBay 'CB001';