namespace JessesPizzaKitchen.Models
{
    public enum MenuItemType
    {
        MainPage,
        Settings
    }
    public class HomeMenuItem
    {
        public MenuItemType Id { get; set; }

        public string Title { get; set; }
    }
}
