using PetCareWebApi.Controllers.Data.ValueObject;
using PetCareWebApi.Models;

namespace PetCareWebApi.Repository
    {
    public interface IConsultaRepository
        {
        Task<IEnumerable<Consulta>> FindAll();
        Task<Consulta> FindById(long id);
        Task<Consulta> Create(Consulta consulta);
        Task<Consulta> Update(Consulta consulta);
        Task<bool> Delete(long id);
        }
    }
