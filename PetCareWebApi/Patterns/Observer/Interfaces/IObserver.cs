namespace PetCareWebApi.Patterns.Observer.Interfaces
{
    public interface IObserver
    {
        Task Update(string message, object data);
    }
}
