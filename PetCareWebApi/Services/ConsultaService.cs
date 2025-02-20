using AutoMapper;
using PetCareWebApi.Controllers.Data.ValueObject;
using PetCareWebApi.Models;
using PetCareWebApi.Patterns.Observer.Base;
using PetCareWebApi.Repository;

namespace PetCareWebApi.Services
{
    public class ConsultaService : NotificationSubject
    {
        private readonly IConsultaRepository _consultaRepository;
        private readonly IMapper _mapper;

        public ConsultaService(IConsultaRepository consultaRepository, IMapper mapper)
        {
            _consultaRepository = consultaRepository;
            _mapper = mapper;
        }

        public async Task<ConsultaVO> Create(ConsultaVO vo)
        {
            // Mapeamento de VO para entidade
            var consulta = _mapper.Map<Consulta>(vo);

            // Persistência via repositório
            var consultaCriada = await _consultaRepository.Create(consulta);

            // Mapeamento de volta para VO
            var consultaVO = _mapper.Map<ConsultaVO>(consultaCriada);

            // Notificação
            await NotifyObservers("Consulta Criada", consultaVO);

            return consultaVO;
        }
    }
}
