using System;
using System.Collections.Generic;
using System.Text;
using Telerik.XamarinForms.Common.DataAnnotations;

namespace JessesPizza.Core.Models.Identity
{
    public class Address
    {
        public Address()
        {
        }
        public Address(CustomerInfo info)
        {
            Id = Guid.NewGuid();
            DisplayName = "Default";
            AddressLine1 = info.Address;
            City = info.City;
            ZipCode = info.ZipCode;
            IsDefault = true;

        }
        public Guid Id { get; set; }
        public string DisplayName { get; set; }
        public string AddressLine1 { get; set; }
        public string City { get; set; }
        public string ZipCode { get; set; }

        public bool IsDefault { get; set; }

    }
}
