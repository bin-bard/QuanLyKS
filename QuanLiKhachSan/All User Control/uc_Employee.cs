using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Data.SqlClient;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace QuanLiKhachSan.All_User_Control
{
    public partial class uc_Employee : UserControl
    {
        DBconnection db = new DBconnection();

        public uc_Employee()
        {
            InitializeComponent();
            viewEmpGridView.CellClick += new DataGridViewCellEventHandler(viewEmpGridView_CellContentClick);

        }

        private void tabPage1_Click(object sender, EventArgs e)
        {

        }

        private void guna2TabControl1_SelectedIndexChanged(object sender, EventArgs e)
        {

        }

        private void guna2ComboBox1_SelectedIndexChanged(object sender, EventArgs e)
        {

        }

        private void label11_Click(object sender, EventArgs e)
        {

        }

        private void guna2DateTimePicker1_ValueChanged(object sender, EventArgs e)
        {

        }

        private void label9_Click(object sender, EventArgs e)
        {

        }

        private void label10_Click(object sender, EventArgs e)
        {

        }

        private void txtGioitinh_SelectedIndexChanged(object sender, EventArgs e)
        {

        }


        private void button1_Click(object sender, EventArgs e)
        {
            string hoTen = txtTenNV.Text.Trim();
            string gioiTinh = gioiTinhCBX.SelectedItem.ToString();
            DateTime ngaySinh = birthDayDTPicker.Value;
            string sdt = sdtTxtBox.Text.Trim();
            string email = emailTxtBox.Text.Trim();
            string diaChi = txtDiaChi.Text.Trim();
            string queQuan = guna2TextBox2.Text.Trim();
            string chucVu = chucVuCBX.Text.Trim();
            string tenDangNhap = userNameTxtBox.Text.Trim();
            string matKhau = passWordTxtBox.Text.Trim();

            try
            {
                db.RegisterEmployee(hoTen, gioiTinh, ngaySinh, sdt, email, diaChi, queQuan, chucVu, tenDangNhap, matKhau);

                // Hiển thị thông báo thành công
                MessageBox.Show("Nhân viên đã được thêm thành công!", "Thông báo", MessageBoxButtons.OK, MessageBoxIcon.Information);
            }
            catch (Exception ex)
            {
                // Hiển thị thông báo lỗi
                MessageBox.Show("Có lỗi xảy ra: " + ex.Message, "Lỗi", MessageBoxButtons.OK, MessageBoxIcon.Error);
            }
            idLbl.Text = db.GetNewId().ToString();
        }

        private void textBox5_TextChanged(object sender, EventArgs e)
        {

        }

        private void label7_Click(object sender, EventArgs e)
        {

        }

        private void textBox6_TextChanged(object sender, EventArgs e)
        {

        }

        private void label8_Click(object sender, EventArgs e)
        {

        }

        private void textBox4_TextChanged(object sender, EventArgs e)
        {

        }

        private void label6_Click(object sender, EventArgs e)
        {

        }

        private void textBox3_TextChanged(object sender, EventArgs e)
        {

        }

        private void textBox2_TextChanged(object sender, EventArgs e)
        {

        }

        private void label5_Click(object sender, EventArgs e)
        {

        }

        private void label4_Click(object sender, EventArgs e)
        {

        }

        private void label3_Click(object sender, EventArgs e)
        {

        }

        private void tabPage3_Click(object sender, EventArgs e)
        {

        }

        private void tabPage4_Click(object sender, EventArgs e)
        {

        }

        private void tabPage5_Click(object sender, EventArgs e)
        {

        }

        private void tabPage2_Click(object sender, EventArgs e)
        {

        }

        private void guna2HtmlLabel1_Click(object sender, EventArgs e)
        {

        }

        private void txtTenNV_TextChanged(object sender, EventArgs e)
        {

        }

        private void sdtTxtBox_TextChanged(object sender, EventArgs e)
        {

        }

        private void emailTxtBox_TextChanged(object sender, EventArgs e)
        {

        }



        private void idLbl_Click(object sender, EventArgs e)
        {
            int newId = db.GetNewId();
            idLbl.Text = newId.ToString();
        }



        private void txtDiaChi_TextChanged(object sender, EventArgs e)
        {

        }

        private void idLbl_Click_1(object sender, EventArgs e)
        {
            idLbl.Text = db.GetNewId().ToString();
        }
        private void LoadEmployeesView()
        {
            DataTable employeesList = db.GetEmployees();
            viewEmpGridView.DataSource = employeesList;

            viewEmpGridView.Columns[0].HeaderText = "ID";
            viewEmpGridView.Columns[0].Width = 30;

            viewEmpGridView.Columns[1].HeaderText = "Tên Nhân Viên";
            viewEmpGridView.Columns[1].Width = 120;

            viewEmpGridView.Columns[2].HeaderText = "Giới Tính";
            viewEmpGridView.Columns[2].Width = 40;

            viewEmpGridView.Columns[3].HeaderText = "Ngày Sinh";
            viewEmpGridView.Columns[3].Width = 100;

            viewEmpGridView.Columns[4].HeaderText = "Số Điện Thoại";
            viewEmpGridView.Columns[4].Width = 90;


            viewEmpGridView.Columns[5].HeaderText = "Email";
            viewEmpGridView.Columns[5].Width = 120;

            viewEmpGridView.Columns[6].HeaderText = "Địa Chỉ";
            viewEmpGridView.Columns[6].Width = 130;

            viewEmpGridView.Columns[7].HeaderText = "Quê Quán";
            viewEmpGridView.Columns[7].Width = 120;

            viewEmpGridView.Columns[8].HeaderText = "Chức Vụ";
            viewEmpGridView.Columns[8].Width = 80;

            DataGridViewButtonColumn btnDelete = new DataGridViewButtonColumn();
            btnDelete.HeaderText = "Xóa";
            btnDelete.Name = "btnDelete";
            btnDelete.Text = "X";
            btnDelete.UseColumnTextForButtonValue = true; // Hiển thị văn bản "Xóa" trên nút

            viewEmpGridView.Columns.Add(btnDelete);
            viewEmpGridView.Columns["btnDelete"].Width = 30;
        }

        private void btnLoad_Click(object sender, EventArgs e)
        {
            LoadEmployeesView();
        }

        private void viewEmpGridView_CellContentClick(object sender, DataGridViewCellEventArgs e)
        {
            if (e.ColumnIndex == viewEmpGridView.Columns["btnDelete"].Index && e.RowIndex >= 0)
            {
                int employeeId = Convert.ToInt32(viewEmpGridView.Rows[e.RowIndex].Cells[0].Value);

                DialogResult dialogResult = MessageBox.Show("Bạn có chắc chắn muốn xóa nhân viên này?",
                                                            "Xác nhận xóa",
                                                            MessageBoxButtons.YesNo);
                if (dialogResult == DialogResult.Yes)
                {
                    try
                    {
                        db.DeleteEmployee(employeeId);
                        DataTable employeesList = db.GetEmployees();
                        viewEmpGridView.DataSource = employeesList;
                        MessageBox.Show("Xóa nhân viên thành công!");
                    }
                    catch (Exception ex)
                    {
                        MessageBox.Show("Đã xảy ra lỗi khi xóa nhân viên: " + ex.Message);
                    }
                }
            }
        }

        private void viewEmpGridView_CellContentClick_1(object sender, DataGridViewCellEventArgs e)
        {

        }

        private void loadLuongBtn_Click(object sender, EventArgs e)
        {
            loadLuongView();
        }
        private void loadLuongView()
        {

            DataTable luongTable = db.ViewAllLuong();
            luongViewGrid.DataSource = luongTable;

            luongViewGrid.Columns[0].HeaderText = "ID";
            luongViewGrid.Columns[0].Width = 30;

            luongViewGrid.Columns[1].HeaderText = "Họ Tên Nhân Viên";
            luongViewGrid.Columns[1].Width = 120;

            luongViewGrid.Columns[2].HeaderText = "Lương Căn Bản";
            luongViewGrid.Columns[2].Width = 130;

            luongViewGrid.Columns[3].HeaderText = "Phụ Cấp";
            luongViewGrid.Columns[3].Width = 100;

            luongViewGrid.Columns[4].HeaderText = "Thưởng";
            luongViewGrid.Columns[4].Width = 100;

            luongViewGrid.Columns[5].HeaderText = "Tổng Lương";
            luongViewGrid.Columns[5].Width = 90;



        }

        private void luongViewGrid_CellContentClick(object sender, DataGridViewCellEventArgs e)
        {

        }
    }
}
