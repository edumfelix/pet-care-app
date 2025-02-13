using PetCareWebApi.Controllers.Data.ValueObject;
using PetCareWebApi.Patterns.Observer.Interfaces;

namespace PetCareWebApi.Patterns.Observer.Observers
{
    public class EmailNotificationObserver:IObserver
    {
        public async Task Update(string message, object data)
        {
            if (data is ConsultaVO consulta)
            {
                await SendEmailNotification(consulta);
            }
        }

        private async Task SendEmailNotification(ConsultaVO consulta)
        {
            // Implementação do envio de email
            await Task.CompletedTask;
        }
    }
}
