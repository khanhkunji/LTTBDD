# BÁO CÁO ĐẶC TẢ YÊU CẦU VÀ MÔ HÌNH DỮ LIỆU

**Đề tài 7: Ứng dụng bán linh kiện máy vi tính**

---

## I. MÔ TẢ CHỨC NĂNG HỆ THỐNG

### 1. Phân quyền người dùng (Role-Based Access Control)
Hệ thống quản lý người dùng theo các cấp độ vai trò khác nhau, đáp ứng tính linh hoạt trong vận hành:
* **Khách hàng (User):** Người dùng hệ thống với mục đích tìm kiếm, mua sắm và theo dõi đơn hàng cá nhân.
* **Quản trị viên (Admin):** Nhân viên cửa hàng có quyền quản lý danh mục, sản phẩm và đơn hàng.
* **Quản trị cấp cao (Super Admin):** Quản lý toàn quyền hệ thống, bao gồm cả việc cấp phát, chuyển đổi vai trò (phân quyền) cho các tài khoản Admin khác.

### 2. Chi tiết Chức năng theo Vai trò

#### A. Đối với Khách hàng (User)
* **Quản lý tài khoản:** Đăng ký thành viên (có xác thực/kiểm tra dữ liệu đầu vào) và Đăng nhập hệ thống.
* **Tương tác Sản phẩm:**
  * Tìm kiếm linh kiện theo từ khóa.
  * Xem danh sách sản phẩm theo từng danh mục.
  * Xem thông tin chi tiết của từng sản phẩm.
  * Đánh giá và bình luận sản phẩm (Dữ liệu đánh giá được lưu vào CSDL để tính điểm trung bình).
* **Quản lý Giỏ hàng:**
  * Thêm sản phẩm vào giỏ hàng, cho phép chọn cụ thể "Size" (phiên bản, dung lượng) và số lượng cần mua.
  * Xem thống kê tổng số lượng các sản phẩm hiện có trong giỏ hàng.
* **Quản lý Đơn hàng:** Xem lại lịch sử các đơn hàng đã đặt và trạng thái hiện tại.

#### B. Đối với Quản trị viên (Admin / Super Admin)
* **Quản lý Người dùng:** Thêm mới, xóa, sửa thông tin người dùng và chuyển đổi vai trò (phân quyền).
* **Quản lý Danh mục:** Thêm mới, cập nhật, xóa các danh mục linh kiện máy tính.
* **Quản lý Sản phẩm:** Thêm mới, sửa thông tin, xóa sản phẩm thuộc từng loại danh mục cụ thể.
* **Quản lý Đơn hàng & Thống kê:**
  * Theo dõi và xử lý đơn hàng.
  * Thống kê lượng đặt hàng theo từng user.
  * Lọc dữ liệu theo ngày đặt, tháng đặt và từng loại danh mục.
  * Trích xuất danh sách các sản phẩm bán chạy nhất.

#### C. Các Yêu cầu Hệ thống Khác
* **Thanh toán trực tuyến:** Tích hợp chức năng thanh toán đơn hàng qua các App hoặc Service Online (Ví dụ: VNPay, MoMo, ZaloPay, Bank Transfer).
* **Hiển thị thông minh:** Tự động lọc và hiển thị danh sách "Sản phẩm bán chạy" và "Sản phẩm mới" trên giao diện chính.
* **Hệ thống Rating:** Hiển thị điểm đánh giá (số sao trung bình) minh bạch cho từng sản phẩm thông qua Trigger tự động.
* **Giao diện (UI/UX):** Đảm bảo thiết kế thân thiện, trực quan và dễ thao tác cho mọi đối tượng sử dụng.

---

## II. PHÂN TÍCH THỰC THỂ VÀ THUỘC TÍNH

Dựa trên yêu cầu, cơ sở dữ liệu được cấu trúc thành các thực thể chính sau:

1. **`NGUOIDUNG` (Người dùng):** Lưu trữ thông tin tài khoản (Họ tên, Email, Mật khẩu, SĐT, Địa chỉ). Thuộc tính `vai_tro` xác định quyền hạn.
2. **`DANHMUC` (Danh mục sản phẩm):** Phân loại linh kiện (CPU, RAM, Mainboard...). Hỗ trợ phân cấp danh mục cha - con.
3. **`SANPHAM` (Sản phẩm):** Chứa chi tiết linh kiện (Tên, Giá, Mô tả, Số lượng tồn, Hình ảnh). Liên kết với `DANHMUC`. Chứa các cờ để đánh dấu sản phẩm mới, bán chạy và điểm đánh giá trung bình.
4. **`SANPHAM_SIZE` (Phiên bản/Kích thước):** Phân loại chi tiết của một sản phẩm (Ví dụ: RAM 8GB, 16GB) và số lượng tồn kho tương ứng.
5. **`GIOHANG` & `CHITIET_GIOHANG` (Giỏ hàng):** Lưu trạng thái mua sắm tạm thời của người dùng, chi tiết đến từng sản phẩm, phiên bản và số lượng.
6. **`DONHANG` & `CHITIET_DONHANG` (Đơn hàng):** Lưu thông tin thanh toán, giao hàng, tổng tiền và trạng thái xử lý. Ghi nhận "cứng" mức giá và tên sản phẩm tại thời điểm mua để đảm bảo tính toàn vẹn lịch sử.
7. **`THANHTOAN` (Thanh toán):** Quản lý các giao dịch qua App/Service online, mã giao dịch và trạng thái thanh toán.
8. **`DANHGIA` (Đánh giá):** Liên kết giữa Khách hàng, Sản phẩm và Đơn hàng (chỉ cho phép đánh giá khi đã mua hàng thành công), lưu trữ số sao và bình luận.

---

## III. SƠ ĐỒ THỰC THỂ KẾT HỢP (ERD)

```mermaid
erDiagram
    USER ||--o{ ORDER : "đặt"
    USER ||--o{ CART_ITEM : "có"
    USER ||--o{ REVIEW : "viết"
    
    CATEGORY ||--|{ PRODUCT : "chứa"
    
    PRODUCT ||--o{ ORDER_DETAIL : "nằm trong"
    PRODUCT ||--o{ CART_ITEM : "được thêm vào"
    PRODUCT ||--o{ REVIEW : "nhận"
    
    ORDER ||--|{ ORDER_DETAIL : "bao gồm"

    USER {
        int id PK
        string ho_ten
        string email
        string mat_khau
        tinyint vai_tro
    }
    
    CATEGORY {
        int id PK
        string ten_danh_muc
        int danh_muc_cha_id FK
    }
    
    PRODUCT {
        int id PK
        int danh_muc_id FK
        string ten_san_pham
        decimal gia
        int so_luong_ton
        float diem_danh_gia_tb
    }
    
    CART_ITEM {
        int giohang_id FK
        int sanpham_id FK
        int size_id
        int so_luong
    }
    
    ORDER {
        int id PK
        int nguoidung_id FK
        datetime ngay_dat
        decimal tong_tien
        string trang_thai
    }
    
    ORDER_DETAIL {
        int donhang_id FK
        int sanpham_id FK
        int so_luong
        decimal don_gia
    }
    
    REVIEW {
        int id PK
        int nguoidung_id FK
        int sanpham_id FK
        int donhang_id FK
        tinyint diem
    }
