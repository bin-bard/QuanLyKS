-- Đặt cơ sở dữ liệu ở chế độ SINGLE_USER
USE master
ALTER DATABASE KhachSan SET SINGLE_USER WITH ROLLBACK IMMEDIATE;

-- Sau đó, xóa cơ sở dữ liệu
DROP DATABASE KhachSan;

