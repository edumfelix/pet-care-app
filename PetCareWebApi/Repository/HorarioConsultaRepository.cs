using AutoMapper;
using Microsoft.EntityFrameworkCore;
using PetCareWebApi.Controllers.Data.ValueObject;
using PetCareWebApi.Data;
using PetCareWebApi.Models;

namespace PetCareWebApi.Repository
    {
    public class HorarioConsultaRepository : IHorarioConsultaRepository
        {
        private readonly AppDbContext _context;
        private IMapper _mapper;

        public HorarioConsultaRepository(AppDbContext context, IMapper mapper)
            {
            _context = context;
            _mapper = mapper;
            }
        public async Task<HorarioConsultaVO> Create(HorarioConsultaVO vo)
            {
            HorarioConsulta horarioConsulta = _mapper.Map<HorarioConsulta>(vo);
            _context.HorarioConsultas.Add(horarioConsulta);
            await _context.SaveChangesAsync();
            return _mapper.Map<HorarioConsultaVO>(horarioConsulta);
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
                await _context.SaveChangesAsync(true);
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
            HorarioConsulta? horarioConsulta = await _context.HorarioConsultas
                .Where(s => s.Id == id)
                .FirstOrDefaultAsync();

            return _mapper.Map<HorarioConsultaVO>(horarioConsulta);
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