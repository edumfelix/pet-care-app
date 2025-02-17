namespace PetCareWebApi
{
    public class Settings
    {
        public static string? Secret => Environment.GetEnvironmentVariable("JWT_SECRET");
    }
}
