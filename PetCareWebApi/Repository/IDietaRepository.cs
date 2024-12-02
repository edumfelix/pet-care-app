using PetCareWebApi.Controllers.Data.ValueObject;

namespace PetCareWebApi.Repository
    {
    public interface IDietaRepository
        {
        Task<IEnumerable<DietaVO>> FindAll();
        Task<DietaVO> FindById(long id);
        Task<DietaVO> Create(DietaVO vo);
        Task<DietaVO> Update(DietaVO vo);
        Task<bool> Delete(long id);
        }
    }
