namespace PetCareWebApi.Patterns.Observer.Interfaces
{
    public interface ISubject
    {
        void Attach(IObserver observer);
        void Detach(IObserver observer);
        Task NotifyObservers(string message, object data);
    }
}
