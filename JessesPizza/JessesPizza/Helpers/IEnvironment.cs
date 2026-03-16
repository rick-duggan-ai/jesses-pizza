using System.Threading.Tasks;

namespace JessesPizza.Helpers
{
        public interface IEnvironment
        {
            Theme GetOperatingSystemTheme();
            Task<Theme> GetOperatingSystemThemeAsync();
        }

        public enum Theme { Light, Dark }

}
