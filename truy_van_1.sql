USE BanLinhKienViTinh
GO

IF OBJECT_ID('DANHGIA',         'U') IS NOT NULL DROP TABLE DANHGIA;
IF OBJECT_ID('THANHTOAN',       'U') IS NOT NULL DROP TABLE THANHTOAN;
IF OBJECT_ID('CHITIET_DONHANG', 'U') IS NOT NULL DROP TABLE CHITIET_DONHANG;
IF OBJECT_ID('DONHANG',         'U') IS NOT NULL DROP TABLE DONHANG;
IF OBJECT_ID('CHITIET_GIOHANG', 'U') IS NOT NULL DROP TABLE CHITIET_GIOHANG;
IF OBJECT_ID('GIOHANG',         'U') IS NOT NULL DROP TABLE GIOHANG;
IF OBJECT_ID('SANPHAM_SIZE',    'U') IS NOT NULL DROP TABLE SANPHAM_SIZE;
IF OBJECT_ID('SANPHAM',         'U') IS NOT NULL DROP TABLE SANPHAM;
IF OBJECT_ID('DANHMUC',         'U') IS NOT NULL DROP TABLE DANHMUC;
IF OBJECT_ID('NGUOIDUNG',       'U') IS NOT NULL DROP TABLE NGUOIDUNG;
GO

CREATE TABLE NGUOIDUNG (
    id              INT             NOT NULL IDENTITY(1,1),
    ho_ten          NVARCHAR(100)   NOT NULL,
    email           NVARCHAR(150)   NOT NULL,
    mat_khau        NVARCHAR(255)   NOT NULL,               
    so_dien_thoai   NVARCHAR(15)    NULL,
    dia_chi         NVARCHAR(MAX)   NULL,
    vai_tro         TINYINT         NOT NULL DEFAULT 0,     
    trang_thai      BIT             NOT NULL DEFAULT 1,     
    ngay_tao        DATETIME2       NOT NULL DEFAULT GETDATE(),
    CONSTRAINT PK_NGUOIDUNG     PRIMARY KEY (id),
    CONSTRAINT UQ_NGUOIDUNG_email UNIQUE (email),
    CONSTRAINT CK_NGUOIDUNG_vaiTro CHECK (vai_tro IN (0, 1, 2))
);
GO


CREATE TABLE DANHMUC (
    id              INT             NOT NULL IDENTITY(1,1),
    ten_danh_muc    NVARCHAR(100)   NOT NULL,
    mo_ta           NVARCHAR(MAX)   NULL,
    hinh_anh        NVARCHAR(255)   NULL,
    danh_muc_cha_id INT             NULL,                  
    thu_tu          INT             NOT NULL DEFAULT 0,
    hien_thi        BIT             NOT NULL DEFAULT 1,
    CONSTRAINT PK_DANHMUC PRIMARY KEY (id),
    CONSTRAINT FK_DANHMUC_cha
        FOREIGN KEY (danh_muc_cha_id) REFERENCES DANHMUC (id)
        ON DELETE NO ACTION ON UPDATE NO ACTION              
);
GO

CREATE TABLE SANPHAM (
    id                      INT             NOT NULL IDENTITY(1,1),
    danh_muc_id             INT             NOT NULL,
    ten_san_pham            NVARCHAR(200)   NOT NULL,
    mo_ta_ngan              NVARCHAR(500)   NULL,
    mo_ta_day_du            NVARCHAR(MAX)   NULL,
    gia                     DECIMAL(15,2)   NOT NULL,
    so_luong_ton            INT             NOT NULL DEFAULT 0,
    hinh_anh                NVARCHAR(255)   NULL,
    la_san_pham_moi         BIT             NOT NULL DEFAULT 0,
    la_san_pham_ban_chay    BIT             NOT NULL DEFAULT 0,
    diem_danh_gia_tb        FLOAT           NOT NULL DEFAULT 0.0,  
    luot_danh_gia           INT             NOT NULL DEFAULT 0,
    ngay_tao                DATETIME2       NOT NULL DEFAULT GETDATE(),
    CONSTRAINT PK_SANPHAM PRIMARY KEY (id),
    CONSTRAINT FK_SANPHAM_danhmuc
        FOREIGN KEY (danh_muc_id) REFERENCES DANHMUC (id)
        ON DELETE NO ACTION ON UPDATE NO ACTION
);
GO

CREATE TABLE SANPHAM_SIZE (
    id              INT             NOT NULL IDENTITY(1,1),
    sanpham_id      INT             NOT NULL,
    ten_size        NVARCHAR(20)    NOT NULL,
    so_luong_ton    INT             NOT NULL DEFAULT 0,
    CONSTRAINT PK_SANPHAM_SIZE      PRIMARY KEY (id),
    CONSTRAINT UQ_SANPHAM_SIZE      UNIQUE (sanpham_id, ten_size),
    CONSTRAINT FK_SPSIZE_sanpham
        FOREIGN KEY (sanpham_id) REFERENCES SANPHAM (id)
        ON DELETE CASCADE ON UPDATE CASCADE
);
GO

CREATE TABLE GIOHANG (
    id              INT             NOT NULL IDENTITY(1,1),
    nguoidung_id    INT             NOT NULL,
    ngay_cap_nhat   DATETIME2       NOT NULL DEFAULT GETDATE(),
    CONSTRAINT PK_GIOHANG           PRIMARY KEY (id),
    CONSTRAINT UQ_GIOHANG_user      UNIQUE (nguoidung_id),  -- đảm bảo 1-1
    CONSTRAINT FK_GIOHANG_user
        FOREIGN KEY (nguoidung_id) REFERENCES NGUOIDUNG (id)
        ON DELETE CASCADE ON UPDATE CASCADE
);
GO

CREATE TABLE CHITIET_GIOHANG (
    id                      INT             NOT NULL IDENTITY(1,1),
    giohang_id              INT             NOT NULL,
    sanpham_id              INT             NOT NULL,
    size_id                 INT             NULL,
    so_luong                INT             NOT NULL DEFAULT 1,
    don_gia_tai_thoi_diem   DECIMAL(15,2)   NOT NULL,
    CONSTRAINT PK_CHITIET_GIOHANG   PRIMARY KEY (id),
    CONSTRAINT FK_CTGIO_giohang
        FOREIGN KEY (giohang_id) REFERENCES GIOHANG (id)
        ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT FK_CTGIO_sanpham
        FOREIGN KEY (sanpham_id) REFERENCES SANPHAM (id)
        ON DELETE NO ACTION ON UPDATE NO ACTION,
    CONSTRAINT FK_CTGIO_size
        FOREIGN KEY (size_id) REFERENCES SANPHAM_SIZE (id)
        ON DELETE NO ACTION ON UPDATE NO ACTION
);
GO

CREATE UNIQUE INDEX UQ_CTGIO_sp_size_notnull
    ON CHITIET_GIOHANG (giohang_id, sanpham_id, size_id)
    WHERE size_id IS NOT NULL;
GO

CREATE UNIQUE INDEX UQ_CTGIO_sp_size_null
    ON CHITIET_GIOHANG (giohang_id, sanpham_id)
    WHERE size_id IS NULL;
GO

CREATE TABLE DONHANG (
    id              INT             NOT NULL IDENTITY(1,1),
    nguoidung_id    INT             NOT NULL,
    ma_don_hang     NVARCHAR(50)    NOT NULL,
    ngay_dat        DATETIME2       NOT NULL DEFAULT GETDATE(),
    tong_tien       DECIMAL(15,2)   NOT NULL,
    phi_van_chuyen  DECIMAL(15,2)   NOT NULL DEFAULT 0,
    ho_ten_nhan     NVARCHAR(100)   NOT NULL,
    sdt_nhan        NVARCHAR(15)    NOT NULL,
    dia_chi_nhan    NVARCHAR(MAX)   NOT NULL,
    trang_thai      NVARCHAR(20)    NOT NULL DEFAULT 'cho_xac_nhan',
    ghi_chu         NVARCHAR(MAX)   NULL,
    CONSTRAINT PK_DONHANG           PRIMARY KEY (id),
    CONSTRAINT UQ_DONHANG_ma        UNIQUE (ma_don_hang),
    CONSTRAINT FK_DONHANG_user
        FOREIGN KEY (nguoidung_id) REFERENCES NGUOIDUNG (id)
        ON DELETE NO ACTION ON UPDATE NO ACTION,
    CONSTRAINT CK_DONHANG_trangThai CHECK (
        trang_thai IN ('cho_xac_nhan','dang_xu_ly','dang_giao','hoan_thanh','huy')
    )
);
GO

CREATE INDEX IDX_DONHANG_user     ON DONHANG (nguoidung_id);
CREATE INDEX IDX_DONHANG_ngay     ON DONHANG (ngay_dat);
CREATE INDEX IDX_DONHANG_trangThai ON DONHANG (trang_thai);
GO

CREATE TABLE CHITIET_DONHANG (
    id              INT             NOT NULL IDENTITY(1,1),
    donhang_id      INT             NOT NULL,
    sanpham_id      INT             NOT NULL,
    size_id         INT             NULL,
    so_luong        INT             NOT NULL,
    don_gia         DECIMAL(15,2)   NOT NULL,
    ten_sp_luu      NVARCHAR(200)   NOT NULL,               
    hinh_anh_luu    NVARCHAR(255)   NULL,                   
    CONSTRAINT PK_CHITIET_DONHANG   PRIMARY KEY (id),
    CONSTRAINT FK_CTDH_donhang
        FOREIGN KEY (donhang_id) REFERENCES DONHANG (id)
        ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT FK_CTDH_sanpham
        FOREIGN KEY (sanpham_id) REFERENCES SANPHAM (id)
        ON DELETE NO ACTION ON UPDATE NO ACTION,
    CONSTRAINT FK_CTDH_size
        FOREIGN KEY (size_id) REFERENCES SANPHAM_SIZE (id)
        ON DELETE NO ACTION ON UPDATE NO ACTION
);
GO

CREATE TABLE THANHTOAN (
    id              INT             NOT NULL IDENTITY(1,1),
    donhang_id      INT             NOT NULL,
    phuong_thuc     NVARCHAR(20)    NOT NULL DEFAULT 'cod',
    trang_thai      NVARCHAR(20)    NOT NULL DEFAULT 'cho_thanh_toan',
    ma_giao_dich    NVARCHAR(100)   NULL,
    so_tien         DECIMAL(15,2)   NOT NULL,
    thoi_gian_tt    DATETIME2       NULL,
    noi_dung        NVARCHAR(MAX)   NULL,
    CONSTRAINT PK_THANHTOAN         PRIMARY KEY (id),
    CONSTRAINT UQ_THANHTOAN_don     UNIQUE (donhang_id),    
    CONSTRAINT FK_TT_donhang
        FOREIGN KEY (donhang_id) REFERENCES DONHANG (id)
        ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT CK_TT_phuongThuc CHECK (
        phuong_thuc IN ('cod','vnpay','momo','zalopay','bank_transfer')
    ),
    CONSTRAINT CK_TT_trangThai CHECK (
        trang_thai IN ('cho_thanh_toan','thanh_cong','that_bai','hoan_tien')
    )
);
GO

CREATE TABLE DANHGIA (
    id              INT             NOT NULL IDENTITY(1,1),
    nguoidung_id    INT             NOT NULL,
    sanpham_id      INT             NOT NULL,
    donhang_id      INT             NOT NULL,              
    diem            TINYINT         NOT NULL,
    tieu_de         NVARCHAR(200)   NULL,
    noi_dung        NVARCHAR(MAX)   NULL,
    da_duyet        BIT             NOT NULL DEFAULT 0,   
    ngay_tao        DATETIME2       NOT NULL DEFAULT GETDATE(),
    CONSTRAINT PK_DANHGIA           PRIMARY KEY (id),
    CONSTRAINT UQ_DANHGIA           UNIQUE (nguoidung_id, sanpham_id, donhang_id),
    CONSTRAINT CK_DANHGIA_diem      CHECK (diem BETWEEN 1 AND 5),
    CONSTRAINT FK_DG_user
        FOREIGN KEY (nguoidung_id) REFERENCES NGUOIDUNG (id)
        ON DELETE NO ACTION ON UPDATE NO ACTION,
    CONSTRAINT FK_DG_sanpham
        FOREIGN KEY (sanpham_id) REFERENCES SANPHAM (id)
        ON DELETE NO ACTION ON UPDATE NO ACTION,
    CONSTRAINT FK_DG_donhang
        FOREIGN KEY (donhang_id) REFERENCES DONHANG (id)
        ON DELETE NO ACTION ON UPDATE NO ACTION
);
GO

-- ============================================================
--  TRIGGERS
-- ============================================================

-- Trigger 1: ngay_cap_nhat của GIOHANG khi UPDATE
CREATE OR ALTER TRIGGER trg_GIOHANG_update_time
ON GIOHANG
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE GIOHANG
    SET ngay_cap_nhat = GETDATE()
    FROM GIOHANG g
    INNER JOIN inserted i ON g.id = i.id;
END;
GO

-- Trigger 2:cap nhat diem TB sau khi INSERT đánh giá
CREATE OR ALTER TRIGGER trg_DANHGIA_after_insert
ON DANHGIA
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;

    --chi cap nhat khi da_duyet = 1
    UPDATE sp
    SET
        diem_danh_gia_tb = (
            SELECT ISNULL(AVG(CAST(dg.diem AS FLOAT)), 0)
            FROM DANHGIA dg
            WHERE dg.sanpham_id = sp.id AND dg.da_duyet = 1
        ),
        luot_danh_gia = (
            SELECT COUNT(*)
            FROM DANHGIA dg
            WHERE dg.sanpham_id = sp.id AND dg.da_duyet = 1
        )
    FROM SANPHAM sp
    INNER JOIN inserted i ON sp.id = i.sanpham_id
    WHERE i.da_duyet = 1;
END;
GO

-- Trigger 3: cap nhat diem TB sau khi danh  (vd: admin duyet)
CREATE OR ALTER TRIGGER trg_DANHGIA_after_update
ON DANHGIA
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    -- cap nhat tat ca SP lien quan trong batch UPDATE
    UPDATE sp
    SET
        diem_danh_gia_tb = (
            SELECT ISNULL(AVG(CAST(dg.diem AS FLOAT)), 0)
            FROM DANHGIA dg
            WHERE dg.sanpham_id = sp.id AND dg.da_duyet = 1
        ),
        luot_danh_gia = (
            SELECT COUNT(*)
            FROM DANHGIA dg
            WHERE dg.sanpham_id = sp.id AND dg.da_duyet = 1
        )
    FROM SANPHAM sp
    INNER JOIN inserted i ON sp.id = i.sanpham_id;
END;
GO

--DM GOC
SET IDENTITY_INSERT DANHMUC OFF;

INSERT INTO DANHMUC (ten_danh_muc, mo_ta, danh_muc_cha_id, thu_tu) VALUES
(N'CPU',        N'Bộ vi xử lý',        NULL, 1),
(N'RAM',        N'Bộ nhớ trong',        NULL, 2),
(N'Ổ cứng',    N'Thiết bị lưu trữ',    NULL, 3),
(N'VGA',        N'Card đồ họa',         NULL, 4),
(N'Mainboard',  N'Bo mạch chủ',         NULL, 5);

-- Danh mục con (CPU cha = 1, O cung cha = 3)
INSERT INTO DANHMUC (ten_danh_muc, mo_ta, danh_muc_cha_id, thu_tu) VALUES
(N'Intel',  N'CPU Intel',       1, 1),
(N'AMD',    N'CPU AMD Ryzen',   1, 2),
(N'SSD',    N'Ổ cứng SSD',     3, 1),
(N'HDD',    N'Ổ cứng HDD',     3, 2);

-- Users  (vai_tro: 0=user, 1=admin, 2=superadmin)
INSERT INTO NGUOIDUNG (ho_ten, email, mat_khau, so_dien_thoai, vai_tro) VALUES
(N'Admin Hệ thống', N'admin@linkkien.vn', N'$2b$10$xxxhashedxxx', N'0901000001', 2),
(N'Nguyễn Văn A',   N'user1@gmail.com',   N'$2b$10$xxxhashedxxx', N'0901000002', 0),
(N'Trần Thị B',     N'user2@gmail.com',   N'$2b$10$xxxhashedxxx', N'0901000003', 0);

GO
