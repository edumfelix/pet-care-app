using PetCareWebApi.Controllers.Data.ValueObject;
using PetCareWebApi.Models;

namespace PetCareWebApi.Repository
    {
    public interface IConsultaRepository
        {
        Task<IEnumerable<ConsultaVO>> FindAll();
        Task<ConsultaVO> FindById(long id);
        Task<ConsultaVO> Create(ConsultaVO vo);
        Task<ConsultaVO> Update(ConsultaVO vo);
        Task<bool> Delete(long id);
        }
    }
