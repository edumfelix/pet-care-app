using AutoMapper;
using Microsoft.EntityFrameworkCore;
using PetCareWebApi.Controllers.Data.ValueObject;
using PetCareWebApi.Data;
using PetCareWebApi.Models;
using PetCareWebApi.Patterns.Observer.Base;

namespace PetCareWebApi.Repository
    {
    public class ConsultaRepository : NotificationSubject,IConsultaRepository
    {
        private readonly AppDbContext _context;
        private IMapper _mapper;

        public ConsultaRepository(AppDbContext context, IMapper mapper)
            {
            _context = context;
            _mapper = mapper;
            }

        public async Task<ConsultaVO> Create(ConsultaVO vo)
        {
            Consulta consulta = _mapper.Map<Consulta>(vo);
            _context.Consultas.Add(consulta);
            await _context.SaveChangesAsync();

            // Notificar observers
            var consultaVO = _mapper.Map<ConsultaVO>(consulta);
            await NotifyObservers("Consulta Criada", consultaVO);

            return consultaVO;
        }

        public async Task<bool> Delete(long id) 
            {
            try
                {
                Consulta? consulta = await _context.Consultas
                    .Where(s => s.Id == id)
                    .FirstOrDefaultAsync();

                if (consulta == null)
                    return false;

                _context.Consultas.Remove(consulta);
                await _context.SaveChangesAsync(true);
                return true;
                }
            catch (Exception)
                {
                return false;
                }
            }
        public async Task<IEnumerable<ConsultaVO>> FindAll() 
            {
            List<Consulta> consultas = await _context.Consultas.ToListAsync();
            return _mapper.Map<List<ConsultaVO>>(consultas);
            }
        public async Task<ConsultaVO> FindById(long id) 
            {
            Consulta? consulta = await _context.Consultas
                .Where(s => s.Id == id)
                .FirstOrDefaultAsync();

            return _mapper.Map<ConsultaVO>(consulta);
            }
        public async Task<ConsultaVO> Update(ConsultaVO vo) 
            {
            Consulta consulta = _mapper.Map<Consulta>(vo);
            _context.Consultas.Update(consulta);
            await _context.SaveChangesAsync();
            return _mapper.Map<ConsultaVO>(consulta);
            }
        
        }
    }