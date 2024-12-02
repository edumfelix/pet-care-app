using AutoMapper;
using Microsoft.EntityFrameworkCore;
using PetCareWebApi.Controllers.Data.ValueObject;
using PetCareWebApi.Data;
using PetCareWebApi.Models;

namespace PetCareWebApi.Repository
    {
    public class DietaRepository : IDietaRepository
        {
        private readonly AppDbContext _context;
        private IMapper _mapper;

        public DietaRepository(AppDbContext context, IMapper mapper)
            {
            _context = context;
            _mapper = mapper;
            }
        public async Task<DietaVO> Create(DietaVO vo)
            {
            Dieta dieta = _mapper.Map<Dieta>(vo);
            _context.Dietas.Add(dieta);
            await _context.SaveChangesAsync();
            return _mapper.Map<DietaVO>(dieta);
            }
        public async Task<bool> Delete(long id)
            {
            try
                {
                Dieta? dieta = await _context.Dietas
                    .Where(s => s.Id == id)
                    .FirstOrDefaultAsync();

                if (dieta == null)
                    return false;

                _context.Dietas.Remove(dieta);
                await _context.SaveChangesAsync(true);
                return true;
                }
            catch (Exception)
                {
                return false;
                }
            }
        public async Task<IEnumerable<DietaVO>> FindAll()
            {
            List<Dieta> dietas = await _context.Dietas.ToListAsync();
            return _mapper.Map<List<DietaVO>>(dietas);
            }
        public async Task<DietaVO> FindById(long id)
            {
            Dieta? dieta = await _context.Dietas
                .Where(s => s.Id == id)
                .FirstOrDefaultAsync();

            return _mapper.Map<DietaVO>(dieta);
            }
        public async Task<DietaVO> Update(DietaVO vo)
            {
            Dieta dieta = _mapper.Map<Dieta>(vo);
            _context.Dietas.Update(dieta);
            await _context.SaveChangesAsync();
            return _mapper.Map<DietaVO>(dieta);
            }

        }
    }
    