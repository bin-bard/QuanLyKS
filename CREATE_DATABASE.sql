-- Tạo cơ sở dữ liệu
CREATE DATABASE KhachSan;
GO

-- Sử dụng cơ sở dữ liệu vừa tạo
USE KhachSan;
GO

-- Tạo bảng KHACHSAN
CREATE TABLE KHACHSAN (
    MaKhachSan INT IDENTITY(1,1) CONSTRAINT PK_KHACHSAN PRIMARY KEY,
    Ten NVARCHAR(100) NOT NULL,
    DiaChi NVARCHAR(255),
    SDT NVARCHAR(15) CONSTRAINT UQ_KHACHSAN_SDT UNIQUE,
    Email NVARCHAR(100) CONSTRAINT UQ_KHACHSAN_EMAIL UNIQUE,

    CONSTRAINT CK_KHACHSAN_SDT CHECK (SDT LIKE '[0-9]%' AND LEN(SDT) >= 8),
    CONSTRAINT CK_KHACHSAN_EMAIL CHECK (Email LIKE '%_@__%.__%')
);
GO

CREATE TABLE KHACHHANG (
    MaKH INT IDENTITY(1,1) CONSTRAINT PK_KHACHHANG PRIMARY KEY,
    Ten NVARCHAR(100) NOT NULL,
    NgaySinh DATE,
    DiaChi NVARCHAR(255),
    SDT NVARCHAR(15) CONSTRAINT UQ_KHACHHANG_SDT UNIQUE,
    Email NVARCHAR(100) CONSTRAINT UQ_KHACHHANG_EMAIL UNIQUE,

    CONSTRAINT CK_KHACHHANG_NGAYSINH CHECK (NgaySinh <= GETDATE()),
    CONSTRAINT CK_KHACHHANG_SDT CHECK (SDT LIKE '[0-9]%' AND LEN(SDT) >= 8),
    CONSTRAINT CK_KHACHHANG_EMAIL CHECK (Email LIKE '%_@__%.__%')
);
GO

-- Tạo bảng PHONG
CREATE TABLE PHONG (
    MaPhong INT IDENTITY(1,1) CONSTRAINT PK_PHONG PRIMARY KEY,
    MaKH INT NULL CONSTRAINT FK_PHONG_KHACHHANG FOREIGN KEY REFERENCES KHACHHANG(MaKH),
    MaKhachSan INT CONSTRAINT FK_PHONG_KHACHSAN FOREIGN KEY REFERENCES KHACHSAN(MaKhachSan),
    TenLoaiPhong NVARCHAR(100) NOT NULL,
    LoaiGiuong NVARCHAR(255),
    Gia DECIMAL(10, 2),
    SoPhong INT,
    TinhTrang NVARCHAR(50),

    CONSTRAINT CK_PHONG_GIA CHECK (Gia >= 0),
    CONSTRAINT CK_PHONG_SOPHONG CHECK (SoPhong > 0),
    CONSTRAINT CK_PHONG_TINHTRANG CHECK (TinhTrang IN ('trong', 'sudung'))
);
GO

-- Tạo bảng NHANVIEN
CREATE TABLE NHANVIEN (
    MaNV INT IDENTITY(1,1) CONSTRAINT PK_NHANVIEN PRIMARY KEY,
    MaKhachSan INT CONSTRAINT FK_NHANVIEN_KHACHSAN FOREIGN KEY REFERENCES KHACHSAN(MaKhachSan),
    HoTen NVARCHAR(100) NOT NULL,
    GioiTinh NVARCHAR(10),
    NgaySinh DATE,
    SDT NVARCHAR(15) CONSTRAINT UQ_NHANVIEN_SDT UNIQUE,
    Email NVARCHAR(100) CONSTRAINT UQ_NHANVIEN_EMAIL UNIQUE,
    DiaChi NVARCHAR(255),
    QueQuan NVARCHAR(100),
    ChucVu NVARCHAR(50) NOT NULL,

    CONSTRAINT CK_NHANVIEN_NGAYSINH CHECK (NgaySinh <= GETDATE()),
    CONSTRAINT CK_NHANVIEN_GIOITINH CHECK (GioiTinh IN (N'Nam', N'Nữ', N'Khác')),
    CONSTRAINT CK_NHANVIEN_SDT CHECK (SDT LIKE '[0-9]%' AND LEN(SDT) >= 8),
    CONSTRAINT CK_NHANVIEN_EMAIL CHECK (Email LIKE '%_@__%.__%')
);
GO

-- Tạo bảng HOADON
CREATE TABLE HOADON (
    MaHoaDon INT IDENTITY(1,1) CONSTRAINT PK_HOADON PRIMARY KEY,
    MaNV INT NULL CONSTRAINT FK_HOADON_NHANVIEN FOREIGN KEY REFERENCES NHANVIEN(MaNV),
    MaKH INT CONSTRAINT FK_HOADON_KHACHHANG FOREIGN KEY REFERENCES KHACHHANG(MaKH),
    NgayNhanPhong DATETIME,
    NgayTraPhong DATETIME,
    TongTien DECIMAL(10, 2),
    TrangThai NVARCHAR(50),

    CONSTRAINT CK_HOADON_NGAYNHANPHONG CHECK (NgayNhanPhong <= GETDATE()),
    CONSTRAINT CK_HOADON_NGAYTRAPHONG CHECK (NgayTraPhong >= NgayNhanPhong),
    CONSTRAINT CK_HOADON_TONGTIEN CHECK (TongTien >= 0),
    CONSTRAINT CK_HOADON_TRANGTHAI CHECK (TrangThai IN ('chua-thanh-toan', 'da-thanh-toan'))
);
GO

-- Tạo bảng DICHVU
CREATE TABLE DICHVU (
    MaDichVu INT IDENTITY(1,1) CONSTRAINT PK_DICHVU PRIMARY KEY,
    MaHoaDon INT NULL CONSTRAINT FK_DICHVU_HOADON FOREIGN KEY REFERENCES HOADON(MaHoaDon),
    TenDichVu NVARCHAR(100) NOT NULL,
    MoTa NVARCHAR(255),
    Gia DECIMAL(10, 2),

    CONSTRAINT CK_DICHVU_GIA CHECK (Gia >= 0)
);
GO
-- Tạo bảng SUDUNG
CREATE TABLE SUDUNG (
    MaDichVu INT CONSTRAINT FK_SUDUNG_DICHVU FOREIGN KEY REFERENCES DICHVU(MaDichVu),
    MaKH INT CONSTRAINT FK_SUDUNG_KHACHHANG FOREIGN KEY REFERENCES KHACHHANG(MaKH),
    SoLuong INT,
    TongTienDV INT,

    CONSTRAINT PK_SUDUNG PRIMARY KEY (MaDichVu, MaKH),
    CONSTRAINT CK_SUDUNG_SOLUONG CHECK (SoLuong > 0)
);
GO

-- Tạo bảng KHUYENMAI
CREATE TABLE KHUYENMAI (
    MaKM INT IDENTITY(1,1) CONSTRAINT PK_KHUYENMAI PRIMARY KEY,
    MaNV INT NULL CONSTRAINT FK_KHUYENMAI_NHANVIEN FOREIGN KEY REFERENCES NHANVIEN(MaNV),
    TenKhuyenMai NVARCHAR(100) NOT NULL,
    PhanTramGiam DECIMAL(5, 2),
    NgayBatDau DATE,
    NgayKetThuc DATE,

    CONSTRAINT CK_KHUYENMAI_PHANTRAMGIAM CHECK (PhanTramGiam >= 0 AND PhanTramGiam <= 100),
    CONSTRAINT CK_KHUYENMAI_NGAYBATDAU CHECK (NgayBatDau <= GETDATE()),
    CONSTRAINT CK_KHUYENMAI_NGAYKETTHUC CHECK (NgayKetThuc >= NgayBatDau)
);
GO

-- Tạo bảng LUONG
CREATE TABLE LUONG (
    MaLuong INT IDENTITY(1,1) CONSTRAINT PK_LUONG PRIMARY KEY,
    MaNV INT CONSTRAINT FK_LUONG_NHANVIEN FOREIGN KEY REFERENCES NHANVIEN(MaNV),
    LuongCB DECIMAL(10, 2),
    PhuCap DECIMAL(10, 2),
    Thuong DECIMAL(10, 2),

    CONSTRAINT CK_LUONG_LUONGCB CHECK (LuongCB >= 0),
    CONSTRAINT CK_LUONG_PHUCAP CHECK (PhuCap >= 0),
    CONSTRAINT CK_LUONG_THUONG CHECK (Thuong >= 0)
);
GO

-- Tạo bảng TAIKHOAN
CREATE TABLE TAIKHOAN (
    TenDangNhap NVARCHAR(50) CONSTRAINT PK_TAIKHOAN PRIMARY KEY,
    MaNV INT CONSTRAINT FK_TAIKHOAN_NHANVIEN FOREIGN KEY REFERENCES NHANVIEN(MaNV),
    MatKhau NVARCHAR(255) NOT NULL,
);
GO

-- Create stored procedure to add a branch
CREATE PROCEDURE AddBranch
    @Ten NVARCHAR(100),
    @DiaChi NVARCHAR(255),
    @SDT NVARCHAR(15),
    @Email NVARCHAR(100)
AS
BEGIN
    INSERT INTO KHACHSAN (Ten, DiaChi, SDT, Email)
    VALUES (@Ten, @DiaChi, @SDT, @Email);
END;
GO

-- Create view to see all branches
CREATE VIEW ViewBranches AS
SELECT MaKhachSan, Ten, DiaChi, SDT, Email
FROM KHACHSAN;
GO

CREATE PROCEDURE AddRoom
    @SoPhong NVARCHAR(50),
    @TenLoaiPhong NVARCHAR(50),
    @LoaiGiuong NVARCHAR(50),
    @Gia DECIMAL(18, 2),
    @MaKhachSan INT,
    @TinhTrang NVARCHAR(50) = 'trong'
AS
BEGIN
    INSERT INTO PHONG(SoPhong, TenLoaiPhong, LoaiGiuong, Gia, MaKhachSan, TinhTrang)
    VALUES (@SoPhong, @TenLoaiPhong, @LoaiGiuong, @Gia, @MaKhachSan, @TinhTrang)
END
GO

CREATE VIEW ViewRooms AS
SELECT r.SoPhong, r.TenLoaiPhong, r.LoaiGiuong, r.Gia, r.TinhTrang, b.Ten AS BranchName
FROM PHONG r
JOIN KHACHSAN b ON r.MaKhachSan = b.MaKhachSan;
GO

CREATE PROCEDURE AddDichVu
    @TenDichVu NVARCHAR(100),
    @MoTa NVARCHAR(255),
    @Gia DECIMAL(10, 2)
AS
BEGIN
    INSERT INTO DICHVU ( TenDichVu, MoTa, Gia)
    VALUES (@TenDichVu, @MoTa, @Gia);
END
GO

CREATE VIEW ViewDichVu AS
SELECT MaDichVu,MaHoaDon, TenDichVu, MoTa, Gia
FROM DICHVU;
GO

CREATE PROCEDURE AddKhuyenMai
    @MaNV INT = NULL,
    @TenKhuyenMai NVARCHAR(100),
    @PhanTramGiam DECIMAL(5, 2),
    @NgayBatDau DATE,
    @NgayKetThuc DATE
AS
BEGIN
    INSERT INTO KHUYENMAI (MaNV, TenKhuyenMai, PhanTramGiam, NgayBatDau, NgayKetThuc)
    VALUES (@MaNV, @TenKhuyenMai, @PhanTramGiam, @NgayBatDau, @NgayKetThuc);
END
GO


CREATE VIEW ViewKhuyenMai AS
SELECT MaKM, MaNV, TenKhuyenMai, PhanTramGiam, NgayBatDau, NgayKetThuc
FROM KHUYENMAI;
GO

CREATE FUNCTION GetAvailableRoomsByCriteria
(
    @TenLoaiPhong NVARCHAR(100),
    @LoaiGiuong NVARCHAR(100)
)
RETURNS TABLE
AS
RETURN
(
    SELECT SoPhong, Gia
    FROM PHONG
    WHERE TinhTrang = 'trong' AND TenLoaiPhong = @TenLoaiPhong AND LoaiGiuong = @LoaiGiuong
);
GO

CREATE FUNCTION GetAvailableDichVu
(
    @TenDichVu NVARCHAR(100)
)
RETURNS TABLE
AS
RETURN
(
    SELECT TenDichVu, MoTa
    FROM DICHVU
    WHERE TenDichVu = @TenDichVu
);
GO


CREATE PROCEDURE AddCustomer
    @Ten NVARCHAR(100),
    @NgaySinh DATE,
    @DiaChi NVARCHAR(255),
    @SDT NVARCHAR(15),
    @Email NVARCHAR(100)
AS
BEGIN
    INSERT INTO KHACHHANG (Ten, NgaySinh, DiaChi, SDT, Email)
    VALUES (@Ten, @NgaySinh, @DiaChi, @SDT, @Email);
END;
GO

CREATE VIEW ViewCustomer AS
SELECT 
    MaKH, Ten, NgaySinh, DiaChi,SDT, Email
FROM KHACHHANG;
GO

CREATE PROCEDURE AddCustomerToRoom
(
    @SDT NVARCHAR(15),
    @SoPhong INT,
    @Result NVARCHAR(255) OUTPUT
)
AS
BEGIN
    DECLARE @MaKH INT;

    -- Lấy mã khách hàng dựa trên số điện thoại
    SELECT @MaKH = MaKH
    FROM KHACHHANG
    WHERE SDT = @SDT;

    -- Kiểm tra nếu mã khách hàng không tìm thấy
    IF @MaKH IS NULL
    BEGIN
        SET @Result = 'Khách hàng không tồn tại';
        RETURN;
    END

    -- Cập nhật mã khách hàng vào bảng PHONG
    UPDATE PHONG
    SET MaKH = @MaKH
    WHERE SoPhong = @SoPhong;

    -- Thay đổi trạng thái phòng thành "sudung"
    UPDATE PHONG
    SET TinhTrang = 'sudung'
    WHERE SoPhong = @SoPhong;

    SET @Result = 'Đã thêm khách hàng vào phòng thành công';
END;
GO


CREATE TRIGGER trg_UpdateRoomStatus
ON PHONG
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    -- Kiểm tra nếu có sự thay đổi trong MaKH
    IF UPDATE(MaKH)
    BEGIN
        -- Cập nhật trạng thái phòng thành "sudung" nếu MaKH không NULL
        UPDATE PHONG
        SET TinhTrang = 'sudung'
        WHERE MaKH IS NOT NULL AND TinhTrang = 'trong';

        DECLARE @MaKH INT, @MaPhong INT, @MaHoaDon INT, @NgayNhanPhong DATETIME, @TongTien DECIMAL(10, 2);

        -- Lấy thông tin mã khách hàng và mã phòng đã cập nhật
        SELECT @MaKH = inserted.MaKH, @MaPhong = inserted.MaPhong
        FROM inserted;

        -- Lấy ngày nhận phòng hiện tại
        SET @NgayNhanPhong = GETDATE();

        -- Lấy giá phòng để tính tổng tiền (giả sử phòng được tính theo giá của bảng PHONG)
        SELECT @TongTien = Gia FROM PHONG WHERE MaPhong = @MaPhong;

        -- Tạo hóa đơn mới
        INSERT INTO HOADON (MaKH, NgayNhanPhong, TongTien, TrangThai)
        VALUES (@MaKH, @NgayNhanPhong, @TongTien, 'chua-thanh-toan');
    END
END;
GO

CREATE PROCEDURE AddServiceToCustomer
    @SDT NVARCHAR(15),
    @TenDichVu NVARCHAR(100),
    @MoTa NVARCHAR(255),
    @SoLuong INT
AS
BEGIN
    DECLARE @MaKH INT;
    DECLARE @MaDichVu INT;
    DECLARE @Gia DECIMAL(10, 2);
    DECLARE @TongTien DECIMAL(10, 2);

    -- Lấy mã khách hàng dựa trên số điện thoại
    SELECT @MaKH = MaKH
    FROM KHACHHANG
    WHERE SDT = @SDT;


    -- Kiểm tra nếu mã khách hàng không tìm thấy
    IF @MaKH IS NULL
    BEGIN
        RAISERROR('Khách hàng không tồn tại', 16, 1);
        RETURN;
    END

    -- Lấy mã dịch vụ và giá dịch vụ từ bảng DICHVU
    SELECT @MaDichVu = MaDichVu, @Gia = Gia
    FROM DICHVU
    WHERE TenDichVu = @TenDichVu;

    -- Kiểm tra nếu dịch vụ không tồn tại
    IF @MaDichVu IS NULL
    BEGIN
        RAISERROR('Dịch vụ không tồn tại', 16, 1);
        RETURN;
    END

    -- Tính tổng tiền
    SET @TongTien = @Gia * @SoLuong;

    -- Thêm vào bảng SUDUNG
    INSERT INTO SUDUNG (MaDichVu, MaKH, SoLuong, TongTienDV)
    VALUES (@MaDichVu, @MaKH, @SoLuong, @TongTien);
END;
GO
 
CREATE VIEW ViewInvoiceDetails AS
SELECT 
    h.MaHoaDon,
    k.Ten AS TenKhachHang,
    p.SoPhong,
    h.NgayNhanPhong,
    h.NgayTraPhong,
    SUM(ISNULL(d.Gia, 0) * ISNULL(sd.SoLuong, 0)) AS TongTienDichVu,
    h.TongTien AS TongTienPhong,
    ISNULL(km.PhanTramGiam, 0) AS PhanTramGiam,
    (h.TongTien + SUM(ISNULL(d.Gia, 0) * ISNULL(sd.SoLuong, 0))) * (1 - ISNULL(km.PhanTramGiam, 0) / 100) AS TongTienSauKM,
    h.TrangThai
FROM 
    HOADON h
    JOIN KHACHHANG k ON h.MaKH = k.MaKH
    LEFT JOIN PHONG p ON p.MaKH = k.MaKH
    LEFT JOIN SUDUNG sd ON sd.MaKH = k.MaKH
    LEFT JOIN DICHVU d ON sd.MaDichVu = d.MaDichVu
    LEFT JOIN KHUYENMAI km ON km.MaNV = h.MaNV
WHERE 
    h.TrangThai = 'chua-thanh-toan'
GROUP BY 
    h.MaHoaDon, k.Ten, p.SoPhong, h.NgayNhanPhong, h.NgayTraPhong, h.TongTien, km.PhanTramGiam, h.TrangThai;
GO


CREATE VIEW KhachDangSuDungPhong AS
SELECT 
    k.MaKH,
    k.Ten AS TenKhachHang,
    p.SoPhong,
    p.TenLoaiPhong,      
    p.Gia,      
    p.TinhTrang,      
    p.LoaiGiuong             
FROM 
    KHACHHANG k
JOIN 
    PHONG p ON k.MaKH = p.MaKH 
WHERE 
    p.TinhTrang = 'sudung'; 
GO

CREATE PROCEDURE ThanhToanHoaDon
    @SDT NVARCHAR(15),  -- Thêm SDT của KHACHHANG làm đầu vào
    @MaNV INT
AS
BEGIN
    DECLARE @MaHoaDon INT;

    -- Tìm mã hóa đơn từ số điện thoại khách hàng
    SELECT TOP 1 @MaHoaDon = hd.MaHoaDon
    FROM HOADON hd
    JOIN KHACHHANG kh ON hd.MaKH = kh.MaKH
    WHERE kh.SDT = @SDT AND hd.TrangThai = 'chua-thanh-toan'
    ORDER BY hd.NgayNhanPhong;  -- Ưu tiên hóa đơn gần nhất nếu có nhiều hóa đơn chưa thanh toán

    -- Nếu tìm thấy hóa đơn, cập nhật thông tin
    IF @MaHoaDon IS NOT NULL
    BEGIN
        UPDATE HOADON
        SET TrangThai = 'da-thanh-toan',
            NgayTraPhong = GETDATE(),
            MaNV = @MaNV
        WHERE MaHoaDon = @MaHoaDon;
    END
    ELSE
    BEGIN
        PRINT 'Không tìm thấy hóa đơn chưa thanh toán cho số điện thoại này.';
    END
END;
GO

CREATE TRIGGER trg_UpdateRoomStatusAfterPayment
ON HOADON
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    -- Kiểm tra nếu có sự thay đổi trong trạng thái hóa đơn
    IF UPDATE(TrangThai)
    BEGIN
        DECLARE @MaKH INT;
        DECLARE @MaPhong INT;

        -- Lấy mã khách hàng từ hóa đơn đã cập nhật
        SELECT @MaKH = inserted.MaKH
        FROM inserted
        WHERE TrangThai = 'da-thanh-toan';

        -- Nếu khách hàng đã thanh toán thì cập nhật trạng thái phòng
        IF @MaKH IS NOT NULL
        BEGIN
            -- Lấy mã phòng của khách hàng
            SELECT @MaPhong = MaPhong
            FROM PHONG
            WHERE MaKH = @MaKH;

            -- Cập nhật trạng thái phòng thành 'trong'
            UPDATE PHONG
            SET TinhTrang = 'trong',
                MaKH = NULL
            WHERE MaPhong = @MaPhong;
        END
    END
END;
GO


CREATE VIEW ViewPaidCustomers AS
SELECT 
    h.MaHoaDon,
    k.Ten AS TenKhachHang,
    h.NgayNhanPhong,
    h.NgayTraPhong,
    SUM(ISNULL(d.Gia, 0) * ISNULL(sd.SoLuong, 0)) AS TongTienDichVu,
    h.TongTien AS TongTienPhong,
    ISNULL(km.PhanTramGiam, 0) AS PhanTramGiam,
    (h.TongTien + SUM(ISNULL(d.Gia, 0) * ISNULL(sd.SoLuong, 0))) * (1 - ISNULL(km.PhanTramGiam, 0) / 100) AS TongTienSauKM,
    h.TrangThai
FROM 
    HOADON h
    JOIN KHACHHANG k ON h.MaKH = k.MaKH
    LEFT JOIN SUDUNG sd ON sd.MaKH = k.MaKH
    LEFT JOIN DICHVU d ON sd.MaDichVu = d.MaDichVu
    LEFT JOIN KHUYENMAI km ON km.MaNV = h.MaNV
WHERE 
    h.TrangThai = 'da-thanh-toan'
GROUP BY 
    h.MaHoaDon, k.Ten, h.NgayNhanPhong, h.NgayTraPhong, h.TongTien, km.PhanTramGiam, h.TrangThai;
GO

-- Transaction
CREATE PROCEDURE RegisterEmployee
    @HoTen NVARCHAR(100),
    @GioiTinh NVARCHAR(10),
    @NgaySinh DATE,
    @SDT NVARCHAR(15),
    @Email NVARCHAR(100),
    @DiaChi NVARCHAR(255),
    @QueQuan NVARCHAR(100),
    @ChucVu NVARCHAR(50),
    @TenDangNhap NVARCHAR(50),
    @MatKhau NVARCHAR(255)
AS
BEGIN
    SET NOCOUNT ON;
    
    BEGIN TRY
        -- Bắt đầu Transaction
        BEGIN TRANSACTION;

        DECLARE @MaNV INT;

        -- Thêm nhân viên vào bảng NHANVIEN
        INSERT INTO NHANVIEN (HoTen, GioiTinh, NgaySinh, SDT, Email, DiaChi, QueQuan, ChucVu)
        VALUES (@HoTen, @GioiTinh, @NgaySinh, @SDT, @Email, @DiaChi, @QueQuan, @ChucVu);
        
        -- Lấy mã nhân viên vừa thêm
        SET @MaNV = SCOPE_IDENTITY();

        -- Thêm tài khoản vào bảng TAIKHOAN
        INSERT INTO TAIKHOAN (TenDangNhap, MaNV, MatKhau)
        VALUES (@TenDangNhap, @MaNV, @MatKhau);
        
        -- Cam kết Transaction
        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        -- Nếu có lỗi xảy ra, rollback transaction
        ROLLBACK TRANSACTION;

        -- Trả về thông báo lỗi
        DECLARE @ErrorMessage NVARCHAR(4000);
        SET @ErrorMessage = ERROR_MESSAGE();
        RAISERROR(@ErrorMessage, 16, 1);
    END CATCH
END;
GO

--Transaction
CREATE PROCEDURE DeleteEmployee
    @MaNV INT
AS
BEGIN
    SET NOCOUNT ON;
    
    BEGIN TRY
        -- Bắt đầu Transaction
        BEGIN TRANSACTION;

        -- Xóa các bản ghi liên quan trong bảng KHUYENMAI (hoặc các bảng khác có khóa ngoại đến NHANVIEN)
        DELETE FROM KHUYENMAI
        WHERE MaNV = @MaNV;

        -- Xóa tài khoản liên quan đến nhân viên
        DELETE FROM TAIKHOAN 
        WHERE MaNV = @MaNV;

        -- Xóa nhân viên từ bảng NHANVIEN
        DELETE FROM NHANVIEN 
        WHERE MaNV = @MaNV;

        -- Cam kết Transaction
        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        -- Nếu có lỗi xảy ra, rollback transaction
        ROLLBACK TRANSACTION;

        -- Trả về thông báo lỗi
        DECLARE @ErrorMessage NVARCHAR(4000);
        SET @ErrorMessage = ERROR_MESSAGE();
        RAISERROR(@ErrorMessage, 16, 1);
    END CATCH
END;
GO


CREATE VIEW ViewEmployees AS
SELECT 
    MaNV,
    HoTen,
    GioiTinh,
    NgaySinh,
    SDT,
    Email,
    DiaChi,
    QueQuan,
    ChucVu
FROM 
    NHANVIEN;
GO

-- Thủ tục để xem lương của một nhân viên cụ thể dựa trên mã nhân viên
-- Thủ tục để xem lương của tất cả nhân viên
CREATE PROCEDURE ViewAllLuong
AS
BEGIN
    SELECT 
        nv.MaNV,
        nv.HoTen,
        l.LuongCB,
        l.PhuCap,
        l.Thuong,
        (l.LuongCB + l.PhuCap + l.Thuong) AS TongLuong
    FROM 
        LUONG l
    JOIN 
        NHANVIEN nv ON l.MaNV = nv.MaNV;
END;
GO

--Khi xóa một nhân viên, dữ liệu liên quan đến lương và tài khoản của nhân viên đó cũng sẽ bị xóa
CREATE TRIGGER trg_DeleteEmployee
ON NHANVIEN
AFTER DELETE
AS
BEGIN
    SET NOCOUNT ON;

    -- Xóa dữ liệu trong bảng LUONG liên quan đến nhân viên bị xóa
    DELETE FROM LUONG
    WHERE MaNV IN (SELECT MaNV FROM deleted);

    -- Xóa dữ liệu trong bảng TAIKHOAN liên quan đến nhân viên bị xóa
    DELETE FROM TAIKHOAN
    WHERE MaNV IN (SELECT MaNV FROM deleted);
END;
GO
