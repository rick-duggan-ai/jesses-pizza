class ApiEndpoints {
  ApiEndpoints._();

  // Auth
  static const login = '/api/Auth/UserLogin';
  static const guestLogin = '/api/Auth/GuestLogin';
  static const validateEmail = '/api/Auth/ValidateEmailAddress';
  static const createUser = '/api/Auth/CreateUser';
  static const confirmAccount = '/api/Auth/ConfirmAccount';
  static const resendSignupCode = '/api/Auth/ResendSignupCode';
  static const forgotPassword = '/api/Auth/ForgotPassword';
  static const confirmPasswordChange = '/api/Auth/ConfirmPasswordChange';
  static const resendChangePasswordCode = '/api/Auth/ResendChangePasswordCode';
  static const newPassword = '/api/Auth/NewPassword';
  static const deleteAccount = '/api/Auth/DeleteAccount';

  // Menu
  static const checkHours = '/api/Mongo/CheckHours';
  static const groups = '/api/Mongo/Groups';
  static const mainMenuItems = '/api/Mongo/MainMenuItems';
  static const orderInfo = '/api/Mongo/Transactions/OrderInfo';

  // Orders
  static const postTransaction = '/api/Mongo/PostTransaction';
  static const getHppToken = '/api/Mongo/GetHPPToken';
  static const getOrders = '/api/Mongo/GetOrders';
  static const validateTransaction = '/api/Mongo/ValidateTransaction';
  static const transactionGuid = '/api/Mongo/TransactionGuid';

  // Account
  static const addresses = '/api/Mongo/Addresses';
  static const saveAddress = '/api/Mongo/SaveAddress';
  static const deleteAddress = '/api/Mongo/DeleteAddress';
  static const creditCards = '/api/Mongo/CreditCards';
  static const saveCreditCard = '/api/Mongo/SaveCreditCard';
  static const deleteCard = '/api/Mongo/DeleteCard';
  static const getAccountInfo = '/api/Mongo/GetAccountInfo';

  // Other
  static const privacy = '/api/Mongo/Privacy';
}
