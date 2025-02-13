using PetCareWebApi.Controllers.Data.ValueObject;

namespace PetCareWebApi.Repository
    {
    public interface IHorarioConsultaRepository
        {
        Task<IEnumerable<HorarioConsultaVO>> FindAll();
        Task<HorarioConsultaVO> FindById(long id);
        Task<HorarioConsultaVO> Create(HorarioConsultaVO vo);
        Task<HorarioConsultaVO> Update(HorarioConsultaVO vo);
        Task<bool> Delete(long id);
    }
    }
