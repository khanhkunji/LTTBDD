import java.util.Date;
import java.util.List;

class NguoiDung {
    private int id;
    private String hoTen;
    private String email;
    private String matKhau;
    private int vaiTro;

    // Mối quan hệ
    private GioHang gioHang;
    private List<DonHang> danhSachDonHang;
    private List<DanhGia> danhSachDanhGia;

    // Phương thức
    public void dangKy() {}
    public void dangNhap() {}
    public void capNhatThongTin() {}
}

class DanhMuc {
    private int id;
    private String tenDanhMuc;
    private int danhMucChaId;

    private List<SanPham> danhSachSanPham;

    public void themDanhMuc() {}
    public void suaDanhMuc() {}
    public void xoaDanhMuc() {}
}

class SanPham {
    private int id;
    private String tenSanPham;
    private double gia;
    private int soLuongTon;
    private float diemDanhGiaTb;

    private DanhMuc danhMuc;
    private List<SanPhamSize> danhSachSize;
    private List<ChiTietDonHang> chiTietDonHangs;
    private List<ChiTietGioHang> chiTietGioHangs;
    private List<DanhGia> danhSachDanhGia;

    public void themSanPham() {}
    public void capNhatGia() {}
    public void kiemTraTonKho() {}
}

class SanPhamSize {
    private int id;
    private String tenSize;
    private int soLuongTon;

    private SanPham sanPham;

    public void capNhatSoLuong() {}
}

class GioHang {
    private int id;
    private Date ngayCapNhat;

    private NguoiDung nguoiDung;
    private List<ChiTietGioHang> danhSachChiTiet;

    public void tinhTongTien() {}
    public void lamTrongGio() {}
}

class ChiTietGioHang {
    private int id;
    private int soLuong;

    private GioHang gioHang;
    private SanPham sanPham;
    private SanPhamSize sanPhamSize;

    public void thayDoiSoLuong() {}
    public void xoaKhoiGio() {}
}

class DonHang {
    private int id;
    private String maDonHang;
    private Date ngayDat;
    private double tongTien;
    private String trangThai;

    private NguoiDung nguoiDung;
    private ThanhToan thanhToan;
    private List<ChiTietDonHang> danhSachChiTiet;

    public void taoDonHang() {}
    public void capNhatTrangThai() {}
    public void huyDonHang() {}
}

class ChiTietDonHang {
    private int id;
    private int soLuong;
    private double donGiaLuu;

    private DonHang donHang;
    private SanPham sanPham;
    private SanPhamSize sanPhamSize;

    public void tinhThanhTien() {}
}

class ThanhToan {
    private int id;
    private String phuongThuc;
    private String trangThai;

    private DonHang donHang;

    public void xulyThanhToan() {}
    public void hoanTien() {}
}

class DanhGia {
    private int id;
    private int diem;
    private String noiDung;

    private NguoiDung nguoiDung;
    private SanPham sanPham;
    private DonHang donHang;

    public void vietDanhGia() {}
    public void duyetDanhGia() {}
}