namespace JessesPizzaKitchen.Services
{
    public class MenuItemManager
    {
        private IMongoService _mongoService;

        public MenuItemManager(IMongoService mongoService)
        {
            _mongoService = mongoService;
        }
        
    }
}
