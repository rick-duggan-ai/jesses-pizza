using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using AspNetCore.Identity.MongoDbCore.Models;
using JessesPizza.Core.Models;
using JessesPizza.Core.Models.Transactions;
using Microsoft.AspNetCore.Identity;
using JessesPizza.Core.Models.Identity;
using Destructurama.Attributed;

namespace JessesApi.Areas.Identity.Data
{
	// Add profile data for application users by adding properties to the JessesAppUser class
	public class JessesAppUser : MongoIdentityUser<Guid>
	{
		[NotLogged]
		public List<CreditCard> CreditCards { get; set; }
		[NotLogged]
		public List<Address> Addresses { get; set; }
		[NotLogged]
		public List<Guid> TransactionIds { get; set; }

		public CustomerInfo Info { get; set; }
		public bool AccountVerified { get; set; } 

		public JessesAppUser() : base()
		{

		}

		public JessesAppUser(string userName, string email) : base(userName, email)
		{
		}
		public JessesAppUser(SignUpRequest request) : base()
		{
			Random generator = new Random();
			Info = request.Info;
			Addresses = new List<Address>()
			{
				new Address()
				{
					Id= Guid.NewGuid(),
					DisplayName = "Default Address",
					AddressLine1 = request.Info.Address,
					City =  request.Info.City  ,
					ZipCode = request.Info.ZipCode,
					IsDefault = true
				}
			};
			CreditCards = new List<CreditCard>();
			TransactionIds = new List<Guid>();
			UserName = request.Email;
			Email = request.Email;
			PhoneNumber = Info.PhoneNumber;
			AccountVerified = false;
		}
	}

	public class JessesAppRole : MongoIdentityRole<Guid>
	{
		public JessesAppRole() : base()
		{
		}

		public JessesAppRole(string roleName) : base(roleName)
		{
		}
	}
}
