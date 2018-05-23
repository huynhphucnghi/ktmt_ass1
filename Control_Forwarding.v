// This module is used to solve control hazard issue, based on our idea (Duy & Nghi)
// Hướng giải quyết thông thường cho control hazard là sử dụng tiên đoán. Trong đó lệnh branch sẽ quyết định có 
// rẽ nhánh hay không ở giai đoạn MEM, nếu tiên đoán đúng thì sẽ được lợi 3 lệnh, còn nếu tiên đoán sai thì
// phải hủy bỏ 3 lệnh trước đó và không được lợi hay hại gì cả.
// Nhưng thay vì phải tới giai đoạn MEM mới quyết định có branch hay không thì hơi trễ vì ta có thể biết trước 
// được ở giai đoạn ID, sách KTMT cũng đã giới thiệu cách thức này (Trang 240).
// Tuy nhiên ở phương pháp này có 1 nhược điểm đó là sẽ bị gặp lại rủi ro về dữ liệu (data hazard)
// Ví dụ đoạn lệnh sau:
// addi $s0, $s0, 16
// beq $s0, $s1, 100
// Ở đoạn lệnh trên thì lệnh addi sẽ không thể ghi kịp vào Register để lệnh beq có thể truy xuất giá trị chính xác
// của thanh ghi $s0. Ngay cả khối Forwarding cũng sẽ không hoạt động vì phải chờ tới khi lệnh addi đang ở giai đoạn
// MEM thì mới có thể thực hiện forwarding, nhưng lúc đó đã quá trễ vì lệnh branch đã thực hiện xong nhiệm vụ.
// Khối Control Forwarding được sinh ra để giải quyết vấn đề này. Lấy ý tưởng từ khối Forwarding thông thương
// nhưng khác ở chỗ là Control Forwarding sẽ forward dữ liệu từ giai đoạn EX về ID để hỗ trợ lệnh rẽ nhánh có điều kiện.

module Control_Forwarding(
	input ID_EX_RegWrite,
	input [4:0] ID_EX_rd, IF_ID_rs, IF_ID_rt,
	output [1:0] F
);

	assign F[0] = (ID_EX_RegWrite && ID_EX_rd == IF_ID_rs) ? 1'b1 : 1'b0;
	assign F[1] = (ID_EX_RegWrite && ID_EX_rd == IF_ID_rt) ? 1'b1 : 1'b0;

endmodule