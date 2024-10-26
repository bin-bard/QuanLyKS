using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace QuanLiKhachSan.All_User_Control
{
    public partial class UC_CustomerControl : UserControl
    {
        DBconnection db = new DBconnection();
        public UC_CustomerControl()
        {
            InitializeComponent();
        }

        private void uc_CustomerControl_Load(object sender, EventArgs e)
        {

        }

        private void txtSeachAll_SelectedIndexChanged(object sender, EventArgs e)
        {
            if (txtSeachAll.SelectedItem.ToString() == "All-Customer-Details")
            {
                LoadAllCustomerDetails();
            }
            else if (txtSeachAll.SelectedItem.ToString() == "Customer-In-Hotel")
            {
                LoadAllCustomerInHotel();
            }
            else if (txtSeachAll.SelectedItem.ToString() == "Check-Out-Customer")
            {
                LoadAllCustomerCheckOut();
            }
        }

        private void LoadAllCustomerDetails()
        {
            DataTable dtCustomers = db.GetCustomers();
            dataGridViewAllCustomers.DataSource = dtCustomers;
        }


        private void LoadAllCustomerInHotel()
        {
            DataTable dtCustomerInHotel = db.GetCustomersInHotel();
            dataGridViewAllCustomers.DataSource = dtCustomerInHotel;
        }

        private void LoadAllCustomerCheckOut()
        {
            DataTable dtCustomerCheckOut = db.GetCustomersCheckOut();
            dataGridViewAllCustomers.DataSource = dtCustomerCheckOut;
        }

        private void dataGridViewAllCustomers_CellContentClick(object sender, DataGridViewCellEventArgs e)
        {

        }
    }
}
