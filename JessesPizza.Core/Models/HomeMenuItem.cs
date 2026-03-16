namespace JessesPizza.Core.Models
{
    public enum MenuItemType
    {
        Menu,
        MainMenu,
        Account,
        Contact,
        Orders,
        About,
        
    }
    public class HomeMenuItem
    {
        public MenuItemType Id { get; set; }

        public string Title { get; set; }
        public string Icon { get; set; }
    }
}
