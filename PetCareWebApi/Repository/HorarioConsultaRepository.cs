using AutoMapper;
using Microsoft.EntityFrameworkCore;
using PetCareWebApi.Controllers.Data.ValueObject;
using PetCareWebApi.Data;
using PetCareWebApi.Models;
using PetCareWebApi.Patterns.Sigleton;

namespace PetCareWebApi.Repository
    {
    public class HorarioConsultaRepository : IHorarioConsultaRepository
        {
        private readonly IAppDbContext _context;
        private IMapper _mapper;
        private HorarioCache _cache;

        public HorarioConsultaRepository(IAppDbContext context, IMapper mapper)
            {
            _context = context;
            _mapper = mapper;
            _cache = HorarioCache.Instance;
        }
        public async Task<HorarioConsultaVO> Create(HorarioConsultaVO vo)
        {
            HorarioConsulta horarioConsulta = _mapper.Map<HorarioConsulta>(vo);
            _context.HorarioConsultas.Add(horarioConsulta);
            await _context.SaveChangesAsync();

            var horarioVO = _mapper.Map<HorarioConsultaVO>(horarioConsulta);
            _cache.AddOrUpdate(horarioVO);

            return horarioVO;
        }
        public async Task<bool> Delete(long id)
        {
            try
            {
                HorarioConsulta? horarioConsulta = await _context.HorarioConsultas
                    .Where(s => s.Id == id)
                    .FirstOrDefaultAsync();

                if (horarioConsulta == null)
                    return false;

                _context.HorarioConsultas.Remove(horarioConsulta);
                await _context.SaveChangesAsync();

                _cache.Remove(id);
                return true;
            }
            catch (Exception)
            {
                return false;
            }
        }
        public async Task<IEnumerable<HorarioConsultaVO>> FindAll()
        {
            List<HorarioConsulta> horarioConsultas = await _context.HorarioConsultas.ToListAsync();
            return _mapper.Map<List<HorarioConsultaVO>>(horarioConsultas);
        }
        public async Task<HorarioConsultaVO> FindById(long id)
        {
            // Tenta buscar do cache primeiro
            if (_cache.TryGetHorario(id, out var cachedHorario) && cachedHorario != null)
            {
                return cachedHorario;
            }

            // Se não estiver no cache, busca do banco
            HorarioConsulta? horarioConsulta = await _context.HorarioConsultas
                .Where(s => s.Id == id)
                .FirstOrDefaultAsync();

            var horarioVO = _mapper.Map<HorarioConsultaVO>(horarioConsulta);

            // Adiciona ao cache para futuras consultas
            if (horarioVO != null)
            {
                _cache.AddOrUpdate(horarioVO);
            }
            return horarioVO;
        }
        public async Task<HorarioConsultaVO> Update(HorarioConsultaVO vo)
            {
            HorarioConsulta horarioConsulta = _mapper.Map<HorarioConsulta>(vo);
            _context.HorarioConsultas.Update(horarioConsulta);
            await _context.SaveChangesAsync();
            return _mapper.Map<HorarioConsultaVO>(horarioConsulta);
            }
        }
    }