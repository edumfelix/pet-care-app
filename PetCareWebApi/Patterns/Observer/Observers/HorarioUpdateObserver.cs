using PetCareWebApi.Controllers.Data.ValueObject;
using PetCareWebApi.Patterns.Observer.Interfaces;
using PetCareWebApi.Repository;

namespace PetCareWebApi.Patterns.Observer.Observers
{
    public class HorarioUpdateObserver : IObserver
    {
        private readonly IHorarioConsultaRepository _horarioRepository;

        public HorarioUpdateObserver(IHorarioConsultaRepository horarioRepository)
        {
            _horarioRepository = horarioRepository;
        }

        public async Task Update(string message, object data)
        {
            if (data is ConsultaVO consulta)
            {
                var horario = await _horarioRepository.FindById(consulta.IdHorario);
                if (horario != null)
                {
                    horario.Disponibilidade = false;
                    await _horarioRepository.Update(horario);
                }
            }
        }
    }
}
