BÁO CÁO ĐẶC TẢ YÊU CẦU VÀ MÔ HÌNH DỮ LIỆU
Đề tài 7: Ứng dụng bán linh kiện máy vi tính

I. MÔ TẢ CHỨC NĂNG HỆ THỐNG
1. Phân quyền người dùng (Role-Based Access Control)
Hệ thống quản lý người dùng theo các cấp độ vai trò khác nhau, đáp ứng tính linh hoạt trong vận hành:

Khách hàng (User): Người dùng hệ thống với mục đích tìm kiếm, mua sắm và theo dõi đơn hàng.

Quản trị viên (Admin): Nhân viên cửa hàng có quyền quản lý danh mục, sản phẩm và đơn hàng.

Quản trị cấp cao (Super Admin): Quản lý toàn quyền, bao gồm cả việc cấp phát, chuyển đổi vai trò cho các tài khoản Admin khác.

2. Chi tiết Chức năng theo Vai trò
A. Đối với Khách hàng (User)

Quản lý tài khoản: Đăng ký thành viên (có xác thực/kiểm tra dữ liệu đầu vào) và Đăng nhập hệ thống.

Tương tác Sản phẩm:

Tìm kiếm linh kiện theo từ khóa.

Xem danh sách sản phẩm theo từng danh mục.

Xem thông tin chi tiết của từng sản phẩm.

Đánh giá và bình luận sản phẩm (Dữ liệu đánh giá được lưu vào CSDL để tính điểm trung bình).

Quản lý Giỏ hàng:

Thêm sản phẩm vào giỏ hàng, cho phép chọn cụ thể "Size" (phiên bản, dung lượng) và số lượng cần mua.

Xem thống kê tổng số lượng các sản phẩm hiện có trong giỏ hàng.

Quản lý Đơn hàng: Xem lại lịch sử các đơn hàng đã đặt và trạng thái hiện tại.

B. Đối với Quản trị viên (Admin / Super Admin)

Quản lý Người dùng: Thêm mới, xóa, sửa thông tin người dùng và chuyển đổi vai trò (phân quyền).

Quản lý Danh mục: Thêm mới, cập nhật, xóa các danh mục linh kiện máy tính.

Quản lý Sản phẩm: Thêm mới, sửa thông tin, xóa sản phẩm thuộc từng loại danh mục cụ thể.

Quản lý Đơn hàng & Thống kê:

Theo dõi và xử lý đơn hàng.

Thống kê lượng đặt hàng theo từng user.

Lọc dữ liệu theo ngày đặt, tháng đặt và từng loại danh mục.

Trích xuất danh sách các sản phẩm bán chạy nhất.

C. Các Yêu cầu Hệ thống Khác

Thanh toán trực tuyến: Tích hợp chức năng thanh toán đơn hàng qua các App hoặc Service Online (Ví dụ: VNPay, MoMo, ZaloPay...).

Hiển thị thông minh: Tự động lọc và hiển thị danh sách "Sản phẩm bán chạy" và "Sản phẩm mới" trên giao diện chính.

Hệ thống Rating: Hiển thị điểm đánh giá (số sao trung bình) minh bạch cho từng sản phẩm.

Giao diện (UI/UX): Đảm bảo thiết kế thân thiện, trực quan và dễ thao tác cho mọi đối tượng sử dụng.

II. PHÂN TÍCH THỰC THỂ VÀ THUỘC TÍNH (ERD)
Dựa trên yêu cầu, cơ sở dữ liệu được cấu trúc thành các thực thể chính sau:

1. NGUOIDUNG (Người dùng)

Lưu trữ thông tin tài khoản (Họ tên, Email, Mật khẩu, SĐT, Địa chỉ).

Thuộc tính vai_tro xác định quyền hạn (User, Admin).

2. DANHMUC (Danh mục sản phẩm)

Phân loại linh kiện (CPU, RAM, Mainboard...). Hỗ trợ phân cấp danh mục cha - con.

3. SANPHAM (Sản phẩm)

Chứa chi tiết linh kiện (Tên, Giá, Mô tả, Số lượng tồn, Hình ảnh).

Liên kết với DANHMUC. Chứa các cờ (flag) để đánh dấu "Sản phẩm mới", "Sản phẩm bán chạy" và lưu điểm đánh giá trung bình.

4. SANPHAM_SIZE (Phiên bản/Kích thước sản phẩm)

Phân loại chi tiết của một sản phẩm (Ví dụ: SSD 256GB, SSD 512GB) và số lượng tồn kho tương ứng.

5. GIOHANG & CHITIET_GIOHANG (Giỏ hàng)

Lưu trạng thái mua sắm tạm thời của người dùng, chi tiết đến từng sản phẩm, phiên bản (size) và số lượng.

6. DONHANG & CHITIET_DONHANG (Đơn hàng)

Đơn hàng: Lưu thông tin thanh toán, giao hàng, tổng tiền và trạng thái xử lý.

Chi tiết đơn hàng: Ghi nhận "cứng" mức giá và tên sản phẩm tại thời điểm mua để đảm bảo lịch sử không bị sai lệch khi giá sản phẩm thay đổi.

7. THANHTOAN (Thanh toán)

Quản lý các giao dịch qua App/Service online, mã giao dịch và trạng thái thanh toán.

8. DANHGIA (Đánh giá)

Liên kết giữa Khách hàng, Sản phẩm và Đơn hàng (chỉ cho phép đánh giá khi đã mua), lưu trữ số sao và bình luận.
