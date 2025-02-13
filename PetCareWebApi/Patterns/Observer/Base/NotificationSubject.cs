using PetCareWebApi.Patterns.Observer.Interfaces;

namespace PetCareWebApi.Patterns.Observer.Base
{
    public class NotificationSubject:ISubject
    {

        private List<IObserver> _observers = new();

        public void Attach(IObserver observer)
        {
            _observers.Add(observer);
        }

        public void Detach(IObserver observer)
        {
            _observers.Remove(observer);
        }

        public async Task NotifyObservers(string message, object data)
        {
            foreach (var observer in _observers)
            {
                await observer.Update(message, data);
            }
        }
    }
}
