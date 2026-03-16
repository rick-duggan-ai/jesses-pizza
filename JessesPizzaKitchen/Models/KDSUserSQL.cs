using SQLite;
using System;
using System.Collections.Generic;
using System.Text;

namespace JessesPizzaKitchen.Models
{
    public class KDSUserSQL
    {
        [PrimaryKey, AutoIncrement, Column("_id")]
        public int Id { get; set; }
        public string Username { get; set; }
        public string Password { get; set; }
    }
}
